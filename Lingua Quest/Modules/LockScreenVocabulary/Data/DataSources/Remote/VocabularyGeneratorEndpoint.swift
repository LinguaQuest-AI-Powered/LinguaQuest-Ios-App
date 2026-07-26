//
//  VocabularyGeneratorEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

struct VocabularyGeneratorPayload: Encodable {
    let modelId: String
    let messages: [[String: String]]
    
    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case messages
    }
}

struct VocabularyGeneratorEndpoint: AIEndpoint {
    let targetLanguage: String
    let count: Int
    let excludeWords: [String]?
    
    var path: String {
        return "/chat"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var body: VocabularyGeneratorPayload? {
        let excludeInstruction = (excludeWords != nil && !excludeWords!.isEmpty) ? "Do not generate any of the following words: \(excludeWords!.joined(separator: ", ")).\n" : ""
        let prompt = """
        You are a helpful language teacher. You strictly output valid JSON.
        
        Generate a list of \(count) vocabulary words in \(targetLanguage).
        \(excludeInstruction)
        Return the result as a JSON object with a single key "words" containing an array of objects.
        Each object must have the following string properties:
        - "word": The word in \(targetLanguage)
        - "meaning": A description or definition of the word, ALSO IN \(targetLanguage)
        - "exampleSentence": An example sentence using the word, ALSO IN \(targetLanguage)
        - "difficulty": Either "Easy", "Medium", or "Hard"
        Do not include any other text, markdown formatting, or markdown code blocks. Just return the raw JSON string.
        """
        
        return VocabularyGeneratorPayload(
            modelId: "deepseek.v3.2",
            messages: [
                ["role": "user", "content": prompt]
            ]
        )
    }
}
