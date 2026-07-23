//
//  VoiceEvaluationRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

protocol VoiceEvaluationRemoteDataSourceProtocol {
    func evaluateSpokenText(spokenText: String, targetText: String) async throws -> VoiceEvaluationResponseDTO
}

class VoiceEvaluationRemoteDataSource: VoiceEvaluationRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func evaluateSpokenText(spokenText: String, targetText: String) async throws -> VoiceEvaluationResponseDTO {
        let endpoint = VoiceEvaluationEndpoint(spokenText: spokenText, targetText: targetText)
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try await apiClient.request(endpoint)
        } catch {
            throw NSError(domain: "VoiceEvaluation", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Error: \(error.localizedDescription)"])
        }
        
        var rawText = bedrockResponse.outputText
        
        // Extract JSON from markdown or introductory text
        if let jsonStart = rawText.range(of: "```json\n"),
           let jsonEnd = rawText.range(of: "\n```", range: jsonStart.upperBound..<rawText.endIndex) {
            rawText = String(rawText[jsonStart.upperBound..<jsonEnd.lowerBound])
        } else if let jsonStart = rawText.firstIndex(of: "{"),
                  let jsonEnd = rawText.lastIndex(of: "}") {
            rawText = String(rawText[jsonStart...jsonEnd])
        }
        
        rawText = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let jsonData = rawText.data(using: .utf8), !jsonData.isEmpty else {
            throw NSError(domain: "VoiceEvaluation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty or invalid response from model"])
        }
        
        do {
            let result = try JSONDecoder().decode(VoiceEvaluationResponseDTO.self, from: jsonData)
            return result
        } catch {
            print("JSON DECODING ERROR: \(error)")
            print("Raw text was: \(rawText)")
            throw error
        }
    }
}
