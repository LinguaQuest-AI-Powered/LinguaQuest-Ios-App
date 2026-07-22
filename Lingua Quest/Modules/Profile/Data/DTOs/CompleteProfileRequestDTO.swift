//
//  CompleteProfileRequestDTO.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import Foundation

struct CompleteProfileRequestDTO: Encodable {
    let nativeLanguageId: Int
    let targetLanguageId: Int
    let username: String?
}
