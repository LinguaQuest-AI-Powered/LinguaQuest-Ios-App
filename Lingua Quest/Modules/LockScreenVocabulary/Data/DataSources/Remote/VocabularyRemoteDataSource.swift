//
//  VocabularyRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

final class VocabularyRemoteDataSource: VocabularyRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func generateVocabulary(targetLanguage: String, count: Int, excludeWords: [String]?) async throws -> [VocabularyWordDTO] {
        let endpoint = VocabularyGeneratorEndpoint(targetLanguage: targetLanguage, count: count, excludeWords: excludeWords)
        let response: BedrockResponse = try await apiClient.request(endpoint)
        
        let content = response.outputText
        
        // The content should be a JSON string like: {"words": [...]}
        // Sometimes LLMs wrap JSON in markdown blocks even when told not to.
        let cleanedContent = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        guard let data = cleanedContent.data(using: String.Encoding.utf8) else {
            throw NetworkError.decodingFailed(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid string encoding"]))
        }
        
        do {
            let decoder = JSONDecoder()
            let parsedResponse = try decoder.decode(VocabularyGeneratorResponseDTO.self, from: data)
            return parsedResponse.words
        } catch {
            print("Failed to decode AI response for vocabulary. Content: \(cleanedContent)")
            throw NetworkError.decodingFailed(error)
        }
    }
}
