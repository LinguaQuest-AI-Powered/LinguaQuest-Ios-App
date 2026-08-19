//
//  GeminiEvaluationService.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

final class GeminiEvaluationService {
    
    // MARK: - Request / Response DTOs
    
    struct GenerateContentRequest: Encodable {
        let contents: [Content]
        let systemInstruction: SystemInstruction?
        let generationConfig: GenerationConfig?
    }
    
    struct Content: Encodable {
        let role: String
        let parts: [Part]
    }
    
    struct SystemInstruction: Encodable {
        let parts: [Part]
    }
    
    struct Part: Encodable {
        let text: String
    }
    
    struct GenerationConfig: Encodable {
        let responseMimeType: String
    }
    
    struct GenerateContentResponse: Decodable {
        let candidates: [Candidate]?
    }
    
    struct Candidate: Decodable {
        let content: ContentResponse?
    }
    
    struct ContentResponse: Decodable {
        let parts: [PartResponse]?
    }
    
    struct PartResponse: Decodable {
        let text: String?
    }
    
    // MARK: - Model Fallback
    
    private let candidateModels = [
        "gemini-3.5-flash-lite",
        "gemini-3.1-flash-lite",
        "gemini-3.5-flash",
        "gemini-3.7-flash"
    ]
    
    /// Models that returned 404/400 and should be skipped.
    private var invalidModels: Set<String> = []
    
    /// Last model that succeeded — tried first on the next call.
    private var activeModel: String?
    
    // MARK: - Public API
    
    func evaluateTranscript(prompt: String) async throws -> BossEvaluationResult {
        let apiKey = AppConfig.geminiKey
        guard !apiKey.isEmpty else {
            throw NSError(domain: "GeminiEvaluationService", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "API key is missing."])
        }
        
        let requestPayload = GenerateContentRequest(
            contents: [
                Content(role: "user", parts: [Part(text: prompt)])
            ],
            systemInstruction: nil,
            generationConfig: GenerationConfig(responseMimeType: "application/json")
        )
        
        let jsonText = try await executeWithFallback(apiKey: apiKey, payload: requestPayload)
        
        // Strip markdown backticks if Gemini accidentally includes them
        let cleanedJson = jsonText
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let jsonData = cleanedJson.data(using: .utf8) else {
            throw NSError(domain: "GeminiEvaluationService", code: -5,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON string to data."])
        }
        
        return try JSONDecoder().decode(BossEvaluationResult.self, from: jsonData)
    }
    
    // MARK: - Fallback Logic
    
    private func executeWithFallback(apiKey: String, payload: GenerateContentRequest) async throws -> String {
        // Build ordered list: active model first, then remaining valid candidates
        var modelsToTry: [String] = []
        if let active = activeModel, !invalidModels.contains(active) {
            modelsToTry.append(active)
        }
        for model in candidateModels where !invalidModels.contains(model) && model != activeModel {
            modelsToTry.append(model)
        }
        
        guard !modelsToTry.isEmpty else {
            throw NSError(domain: "GeminiEvaluationService", code: -6,
                          userInfo: [NSLocalizedDescriptionKey: "All candidate Gemini models are unavailable."])
        }
        
        var lastError: Error?
        var lastHttpCode: Int?
        
        for model in modelsToTry {
            do {
                let result = try await sendRequest(model: model, apiKey: apiKey, payload: payload)
                activeModel = model
                return result
            } catch let error as NSError {
                lastError = error
                lastHttpCode = error.code
                
                if error.code == 404 || error.code == 400 {
                    invalidModels.insert(model)
                    print("⚠️ [Evaluation] Model \(model) returned \(error.code) — marking as invalid, trying fallback…")
                } else {
                    print("⚠️ [Evaluation] Model \(model) failed with code \(error.code) — trying fallback…")
                }
            }
        }
        
        print("❌ [Evaluation] All candidate models failed")
        throw lastError ?? NSError(domain: "GeminiEvaluationService", code: lastHttpCode ?? -7,
                                   userInfo: [NSLocalizedDescriptionKey: "All candidate Gemini models failed to generate a response."])
    }
    
    private func sendRequest(model: String, apiKey: String, payload: GenerateContentRequest) async throws -> String {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "GeminiEvaluationService", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "GeminiEvaluationService", code: -3,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid response from server."])
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
            throw NSError(domain: "GeminiEvaluationService", code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: errorMsg])
        }
        
        let apiResponse = try JSONDecoder().decode(GenerateContentResponse.self, from: data)
        guard let text = apiResponse.candidates?.first?.content?.parts?.first?.text,
              !text.isEmpty else {
            throw NSError(domain: "GeminiEvaluationService", code: -4,
                          userInfo: [NSLocalizedDescriptionKey: "Empty response from Gemini."])
        }
        
        return text
    }
}
