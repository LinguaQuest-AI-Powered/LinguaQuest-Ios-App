//
//  LoginDTOs.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct LoginResponseDataDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let user: UserDTO
}

struct TargetLanguageDTO: Decodable {
    let id: Int
    let name: String
    let code: String
}

struct NativeLanguageDTO: Decodable {
    let id: Int?
    let name: String
    let code: String?
    let imageUrl: String?
}

struct UserDTO: Decodable {
    let id: Int
    let username: String?
    let photo: String?
    let nativeLanguage: NativeLanguageDTO?
    let isVerified: Bool
    let targetLanguages: [TargetLanguageDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, username, photo, nativeLanguage, isVerified, targetLanguages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        photo = try container.decodeIfPresent(String.self, forKey: .photo)
        
        if let lang = try? container.decodeIfPresent(NativeLanguageDTO.self, forKey: .nativeLanguage) {
            nativeLanguage = lang
        } else if let str = try? container.decodeIfPresent(String.self, forKey: .nativeLanguage) {
            nativeLanguage = NativeLanguageDTO(id: nil, name: str, code: nil, imageUrl: nil)
        } else {
            nativeLanguage = nil
        }
        
        isVerified = try container.decode(Bool.self, forKey: .isVerified)
        
        // Flexible decoder to safely handle both arrays of objects (Swagger Schema) and flat strings (Swagger Login Example)
        if let objects = try? container.decode([TargetLanguageDTO].self, forKey: .targetLanguages) {
            targetLanguages = objects
        } else if let strings = try? container.decode([String].self, forKey: .targetLanguages) {
            targetLanguages = strings.enumerated().map { index, name in
                TargetLanguageDTO(id: index, name: name, code: "")
            }
        } else {
            targetLanguages = []
        }
    }
}
