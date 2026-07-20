//
//  AuthEnvelopeDTOs.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

/// Generic success envelope: { "success": true, "data": { ... } }
struct SuccessResponseDTO<T: Decodable>: Decodable {
    let success: Bool
    let data: T
}


/// Error envelope: { "success": false, "error": { errorCode, errorKey, errorMessage, ... } }
struct ErrorResponseDTO: Decodable {
    let success: Bool
    let error: ErrorDetailDTO
}

struct ErrorDetailDTO: Decodable {
    let apiPath: String
    let errorCode: Int
    let errorKey: String
    let errorMessage: String
    let errorTime: String
}
