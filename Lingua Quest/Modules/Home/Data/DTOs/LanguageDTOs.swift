//
//  LanguageDTOs.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

struct MyLanguagesResponseDTO: Decodable {
    let success: Bool
    let data: MyLanguagesDataDTO
}

struct MyLanguagesDataDTO: Decodable {
    let languages: [MyTargetLanguageDTO]
}

struct AvailableLanguagesResponseDTO: Decodable {
    let success: Bool
    let data: AvailableLanguagesDataDTO
}

struct AvailableLanguagesDataDTO: Decodable {
    let languages: [AvailableLanguageDTO]
}

struct SwitchActiveLanguageResponseDTO: Decodable {
    let success: Bool
    let data: SwitchActiveLanguageDataDTO
}

struct SwitchActiveLanguageDataDTO: Decodable {
    let activeLanguage: MyTargetLanguageDTO
}

struct MyTargetLanguageDTO: Decodable {
    let id: Int
    let name: String
    let code: String
    let level: Int
    let isActive: Bool
    let progressPercent: Int
}

struct AvailableLanguageDTO: Decodable {
    let id: Int
    let name: String
    let code: String
    let isAdded: Bool
}

// MARK: - Mappers
extension MyTargetLanguageDTO {
    func toDomain() -> MyTargetLanguage {
        return MyTargetLanguage(
            id: id,
            name: name,
            code: code,
            level: level,
            isActive: isActive,
            progressPercent: progressPercent
        )
    }
}

extension AvailableLanguageDTO {
    func toDomain() -> AvailableLanguage {
        return AvailableLanguage(
            id: id,
            name: name,
            code: code,
            isAdded: isAdded
        )
    }
}
