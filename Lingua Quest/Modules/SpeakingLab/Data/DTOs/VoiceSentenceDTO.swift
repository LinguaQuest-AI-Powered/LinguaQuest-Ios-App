//
//  VoiceSentenceDTO.swift
//  Lingua Quest
//
//  Created by siam on 22/07/2026.
//

import Foundation

struct VoiceSentenceDTO: Codable {
    let id: String?
    let text: String?
    let difficulty: String?
    let language: String?
    
    func toEntity() -> VoiceSentence {
        VoiceSentence(
            id: id ?? UUID().uuidString,
            text: text ?? "",
            difficulty: difficulty ?? "Medium",
            language: language ?? "de"
        )
    }
    
    static func fromEntity(_ entity: VoiceSentence) -> VoiceSentenceDTO {
        VoiceSentenceDTO(
            id: entity.id,
            text: entity.text,
            difficulty: entity.difficulty,
            language: entity.language
        )
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id ?? "",
            "text": text ?? "",
            "difficulty": difficulty ?? "Medium",
            "language": language ?? "de"
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> VoiceSentenceDTO {
        VoiceSentenceDTO(
            id: dict["id"] as? String,
            text: dict["text"] as? String,
            difficulty: dict["difficulty"] as? String,
            language: dict["language"] as? String
        )
    }
}
