//
//  MindReaderRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

class MindReaderRemoteDataSource: MindReaderRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    private func extractAndDecode<T: Decodable>(_ rawText: String, type: T.Type) throws -> T {
        var text = rawText
        
        // Extract JSON from markdown or introductory text
        if let jsonStart = text.range(of: "```json\n"),
           let jsonEnd = text.range(of: "\n```", range: jsonStart.upperBound..<text.endIndex) {
            text = String(text[jsonStart.upperBound..<jsonEnd.lowerBound])
        } else if let jsonStart = text.firstIndex(of: "{"),
                  let jsonEnd = text.lastIndex(of: "}") {
            text = String(text[jsonStart...jsonEnd])
        } else if let jsonStart = text.firstIndex(of: "["),
                  let jsonEnd = text.lastIndex(of: "]") {
            text = String(text[jsonStart...jsonEnd])
        }
        
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let jsonData = text.data(using: .utf8), !jsonData.isEmpty else {
            throw NSError(domain: "MindReader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty or invalid response from model"])
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            print("JSON DECODING ERROR: \(error)")
            print("Raw text was: \(text)")
            throw error
        }
    }
    
    func requestNextStep(categoryContext: String, historyPrompt: String, targetLanguage: String, nativeLanguage: String) async throws -> AkinatorStepResponseDTO {
        let endpoint = MindReaderNextStepEndpoint(categoryContext: categoryContext, historyPrompt: historyPrompt, targetLanguage: targetLanguage, nativeLanguage: nativeLanguage)
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try await apiClient.request(endpoint)
        } catch {
            throw NSError(domain: "MindReader", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Error: \(error.localizedDescription)"])
        }
        
        return try extractAndDecode(bedrockResponse.outputText, type: AkinatorStepResponseDTO.self)
    }
    
    func requestQuizChoices(categoryContext: String, correctWordTargetLanguage: String, correctWordNativeLanguage: String, nativeLanguage: String, targetLanguage: String) async throws -> [QuizChoiceDTO] {
        let endpoint = MindReaderQuizEndpoint(categoryContext: categoryContext, correctWordTargetLanguage: correctWordTargetLanguage, correctWordNativeLanguage: correctWordNativeLanguage, nativeLanguage: nativeLanguage, targetLanguage: targetLanguage)
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try await apiClient.request(endpoint)
        } catch {
            throw NSError(domain: "MindReader", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Error: \(error.localizedDescription)"])
        }
        
        let wrapper = try extractAndDecode(bedrockResponse.outputText, type: QuizChoiceWrapperDTO.self)
        return wrapper.choices
    }
    
    func verifyHonesty(categoryContext: String, historyPrompt: String, claimedWord: String, feedbackLanguage: String) async throws -> HonestyResponseDTO {
        let endpoint = MindReaderHonestyEndpoint(categoryContext: categoryContext, historyPrompt: historyPrompt, claimedWord: claimedWord, feedbackLanguage: feedbackLanguage)
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try await apiClient.request(endpoint)
        } catch {
            throw NSError(domain: "MindReader", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Error: \(error.localizedDescription)"])
        }
        
        return try extractAndDecode(bedrockResponse.outputText, type: HonestyResponseDTO.self)
    }
}
