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
    func evaluateSpokenText(spokenText: String, targetText: String) async throws -> VoiceEvaluationResponseDTO {
        let promptText = """
        You are a supportive language coach. The user is practicing speaking a sentence.
        Target Sentence: "\(targetText)"
        What the user actually said (transcribed): "\(spokenText)"
        
        Compare what they said to the Target Sentence.
        1. Identify correctly spoken words and incorrectly spoken (or missing/extra) words.
        2. Provide a score out of 100 based on accuracy.
        3. Give a short, encouraging piece of advice (max 2 sentences).
        
        CRITICAL RULE: If the spoken text is empty or completely unrelated, set rating to 0, correct_words to empty, put all words from the target sentence into wrong_words, and give advice such as "I couldn't understand you. Please try speaking more clearly."
        
        Respond STRICTLY in the following JSON format (no markdown, no backticks, just raw JSON):
        {
            "rating": <integer score between 0 and 100>,
            "correct_words": [<array of correctly spoken words as strings>],
            "wrong_words": [<array of incorrectly spoken or missing words as strings>],
            "advice": "<a short, encouraging tip for improvement>"
        }
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
            throw NSError(domain: "VoiceEvaluation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "VoiceEvaluation", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API Error: \(errorMsg)"])
        }
        
        struct BedrockResponse: Codable {
            let output_text: String
        }
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try JSONDecoder().decode(BedrockResponse.self, from: data)
        } catch {
            let rawString = String(data: data, encoding: .utf8) ?? "Unreadable"
            throw NSError(domain: "VoiceEvaluation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected API Response: \(rawString)"])
        }
        
        var rawText = bedrockResponse.output_text
        
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
