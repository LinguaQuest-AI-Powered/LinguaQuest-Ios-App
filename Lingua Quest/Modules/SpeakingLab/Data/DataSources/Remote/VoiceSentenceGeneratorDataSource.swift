//
//  VoiceSentenceGeneratorDataSource.swift
//  Lingua Quest
//
//  Created by siam on 22/07/2026.
//

import Foundation
import FirebaseAI
import FirebaseAILogic

protocol VoiceSentenceGeneratorDataSourceProtocol {
    func generateSentences(language: String, count: Int) async throws -> [VoiceSentenceDTO]
}

class VoiceSentenceGeneratorDataSource: VoiceSentenceGeneratorDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func generateSentences(language: String, count: Int) async throws -> [VoiceSentenceDTO] {
        let endpoint = VoiceSentenceGeneratorEndpoint(language: language, count: count)
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try await apiClient.request(endpoint)
        } catch {
            throw NSError(domain: "VoiceSentenceGenerator", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Error: \(error.localizedDescription)"])
        }
        
        var rawText = bedrockResponse.outputText
        
        // Sanitize markdown if the model ignored our instructions
        rawText = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        if rawText.hasPrefix("```json") {
            rawText = rawText.dropFirst(7).description
        }
        if rawText.hasPrefix("```") {
            rawText = rawText.dropFirst(3).description
        }
        if rawText.hasSuffix("```") {
            rawText = rawText.dropLast(3).description
        }
        rawText = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let jsonData = rawText.data(using: .utf8), !jsonData.isEmpty else {
            throw NSError(domain: "VoiceSentenceGenerator", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty response content"])
        }
        
        struct GeneratedSentence: Codable {
            let id: String?
            let text: String?
            let difficulty: String?
        }
        
        let generated = try JSONDecoder().decode([GeneratedSentence].self, from: jsonData)
        
        return generated.map { sentence in
            VoiceSentenceDTO(
                id: sentence.id ?? UUID().uuidString,
                text: sentence.text,
                difficulty: sentence.difficulty,
                language: language
            )
        }
    }
}
