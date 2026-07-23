//
//  VoiceEvaluationRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import FirebaseAI
import FirebaseAILogic

protocol VoiceEvaluationRemoteDataSourceProtocol {
    func evaluateAudio(audioData: Data, targetText: String) async throws -> VoiceEvaluationResponseDTO
}

class VoiceEvaluationRemoteDataSource: VoiceEvaluationRemoteDataSourceProtocol {
    func evaluateAudio(audioData: Data, targetText: String) async throws -> VoiceEvaluationResponseDTO {
        let promptText = """
        You are a supportive language coach. The user is practicing speaking a sentence.
        Target Sentence: "\(targetText)"
        
        Analyze the provided audio recording.
        1. Compare what they actually said to the Target Sentence.
        2. Identify correctly pronounced words and incorrectly pronounced (or missing/extra) words.
        3. Provide a score out of 100.
        4. Give a short, encouraging piece of advice (max 2 sentences).
        
        CRITICAL RULE: If the audio is completely silent, incomprehensible, or you cannot hear any speech, you MUST STILL respond with the JSON format below. In this case, set rating to 0, correct_words to empty, put all words from the target sentence into wrong_words, and give advice such as "I couldn't hear you. Please try speaking clearly."
        
        Respond STRICTLY in the following JSON format (no markdown, no backticks, just raw JSON):
        {
            "rating": <integer score between 0 and 100>,
            "correct_words": [<array of correctly pronounced words as strings>],
            "wrong_words": [<array of incorrectly pronounced words as strings>],
            "advice": "<a short, encouraging tip for improvement>"
        }
        """
        
        let url = URL(string: "http://apiaccess.iti.net.eg/api/v1/student/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(AppConfig.aiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // We use Voxtral which is designed for audio understanding
        let base64Audio = audioData.base64EncodedString()
        let combinedContent = "\(promptText)\n\n[Audio Data: data:audio/m4a;base64,\(base64Audio)]"
        
        let payload: [String: Any] = [
            "model_id": "mistral.voxtral-small-24b-2507",
            "max_tokens": 1000,
            "messages": [
                [
                    "role": "user",
                    "content": combinedContent
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
        
        let rawString = String(data: data, encoding: .utf8) ?? "Unreadable response"
        print("RAW BEDROCK RESPONSE: \(rawString)")
        
        struct BedrockResponse: Codable {
            let output_text: String
        }
        
        let bedrockResponse: BedrockResponse
        do {
            bedrockResponse = try JSONDecoder().decode(BedrockResponse.self, from: data)
        } catch {
            throw NSError(domain: "VoiceEvaluation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected API Response Format: \(rawString)"])
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
            throw error
        }
    }
}
