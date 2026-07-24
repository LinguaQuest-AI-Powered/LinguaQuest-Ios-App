//
//  VoiceSentenceGeneratorEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

struct VoiceSentenceGeneratorPayload: Encodable {
    let modelId: String
    let messages: [[String: String]]
    
    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case messages
    }
}

struct VoiceSentenceGeneratorEndpoint: AIEndpoint {
    let language: String
    let count: Int
    
    var path: String {
        return "/chat"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var body: VoiceSentenceGeneratorPayload? {
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
        
        return VoiceSentenceGeneratorPayload(
            modelId: "deepseek.v3.2",
            messages: [
                ["role": "user", "content": promptText]
            ]
        )
    }
}
