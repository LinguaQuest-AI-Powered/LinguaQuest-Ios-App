//
//  VoiceEvaluationEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

struct VoiceEvaluationPayload: Encodable {
    let modelId: String
    let messages: [[String: String]]
    
    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case messages
    }
}

struct VoiceEvaluationEndpoint: AIEndpoint {
    let spokenText: String
    let targetText: String
    
    var path: String {
        return "/chat"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var body: VoiceEvaluationPayload? {
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
        
        return VoiceEvaluationPayload(
            modelId: "deepseek.v3.2",
            messages: [
                ["role": "user", "content": promptText]
            ]
        )
    }
}
