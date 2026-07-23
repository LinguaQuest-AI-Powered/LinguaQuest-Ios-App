//
//  BedrockResponse.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

struct BedrockResponse: Codable {
    let outputText: String
    
    enum CodingKeys: String, CodingKey {
        case outputText = "output_text"
    }
}
