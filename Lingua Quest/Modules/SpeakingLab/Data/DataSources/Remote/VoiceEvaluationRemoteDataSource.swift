//
//  VoiceEvaluationRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import FirebaseAI

protocol VoiceEvaluationRemoteDataSourceProtocol {
    func evaluateAudio(audioData: Data, targetText: String) async throws -> VoiceEvaluationResponseDTO
}

class VoiceEvaluationRemoteDataSource: VoiceEvaluationRemoteDataSourceProtocol {
    private let model: GenerativeModel
    
    init() {
        let config = GenerationConfig(
            temperature: 0.0,
            responseMIMEType: "application/json"
        )
        
        self.model = FirebaseAI.firebaseAI(backend: .googleAI()).generativeModel(
            modelName: "gemini-3.5-flash",
            generationConfig: config
        )
    }
    
    func evaluateAudio(audioData: Data, targetText: String) async throws -> VoiceEvaluationResponseDTO {
        let promptText = """
        You are a supportive language coach. The user is practicing speaking a sentence.
        Target Sentence: "\(targetText)"
        
        Analyze the provided audio recording (in base64 format).
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
        
        let audioPart = InlineDataPart(data: audioData, mimeType: "audio/pcm;rate=16000")
        
        let response = try await model.generateContent(promptText, audioPart)
        
        var rawText = response.text ?? ""
        print("RAW GEMINI RESPONSE:\n\(rawText)") // Print the raw response for debugging
        
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
        
        guard let data = rawText.data(using: .utf8), !data.isEmpty else {
            throw NSError(domain: "VoiceEvaluation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty or invalid response from model"])
        }
        
        do {
            let result = try JSONDecoder().decode(VoiceEvaluationResponseDTO.self, from: data)
            return result
        } catch {
            print("JSON DECODING ERROR: \\(error)")
            throw error
        }
    }
}
