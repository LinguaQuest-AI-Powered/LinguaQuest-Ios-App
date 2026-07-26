//
//  GeminiEvaluationService.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

final class GeminiEvaluationService {
    
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
    
    func evaluateTranscript(prompt: String) async throws -> BossEvaluationResult {
        let apiKey = AppConfig.geminiKey
        guard !apiKey.isEmpty else {
            throw NSError(domain: "GeminiEvaluationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key is missing."])
        }
        
        // Use gemini-flash-latest for the standard evaluation (REST API)
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "GeminiEvaluationService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])
        }
        
        let requestPayload = GenerateContentRequest(
            contents: [
                Content(role: "user", parts: [Part(text: prompt)])
            ],
            systemInstruction: nil,
            generationConfig: GenerationConfig(responseMimeType: "application/json")
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestPayload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "GeminiEvaluationService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server."])
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
            throw NSError(domain: "GeminiEvaluationService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])
        }
        
        let apiResponse = try JSONDecoder().decode(GenerateContentResponse.self, from: data)
        guard let jsonText = apiResponse.candidates?.first?.content?.parts?.first?.text else {
            throw NSError(domain: "GeminiEvaluationService", code: -4, userInfo: [NSLocalizedDescriptionKey: "Empty response from Gemini."])
        }
        
        // Strip markdown backticks if Gemini accidentally includes them despite the prompt
        let cleanedJson = jsonText
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            
        guard let jsonData = cleanedJson.data(using: .utf8) else {
            throw NSError(domain: "GeminiEvaluationService", code: -5, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON string to data."])
        }
        
        return try JSONDecoder().decode(BossEvaluationResult.self, from: jsonData)
    }
}
