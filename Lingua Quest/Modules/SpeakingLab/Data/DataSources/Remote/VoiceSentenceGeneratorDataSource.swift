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
    func generateSentences(language: String, count: Int) async throws -> [VoiceSentenceDTO] {
        let promptText = """
        Generate exactly \(count) unique sentences in \(language) for a language learning app.
        The sentences should be practical, everyday sentences that a learner would use.
        
        Mix the difficulty levels:
        - 2 sentences should be "Easy" (short, simple vocabulary)
        - 2 sentences should be "Medium" (moderate length, common phrases)
        - 1 sentence should be "Hard" (longer, more complex structure)
        
        Respond STRICTLY in the following JSON format (no markdown, no backticks, just raw JSON):
        [
            {
                "id": "<unique_uuid_string>",
                "text": "<the sentence in \(language)>",
                "difficulty": "<Easy|Medium|Hard>"
            }
        ]
        
        IMPORTANT: Generate exactly \(count) sentences. Each id must be a unique UUID string.
        """
        
        let url = URL(string: "http://apiaccess.iti.net.eg/api/v1/student/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(AppConfig.aiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "model_id": "deepseek.v3.2",
            "messages": [
                [
                    "role": "user",
                    "content": promptText
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "VoiceSentenceGenerator", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "VoiceSentenceGenerator", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API Error: \(errorMsg)"])
        }
        
        let rawString = String(data: data, encoding: .utf8) ?? "Unreadable response"
        print("RAW BEDROCK RESPONSE: \(rawString)")
        
        struct BedrockResponse: Codable {
            let output_text: String
        }
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try JSONDecoder().decode(BedrockResponse.self, from: data)
        } catch {
            throw NSError(domain: "VoiceSentenceGenerator", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected API Response Format: \(rawString)"])
        }
        
        var rawText = bedrockResponse.output_text
        
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
