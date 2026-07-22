//
//  FirebaseLoginDTOs..swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import Foundation

struct FirebaseLoginRequestDTO: Encodable {
    let idToken: String
}

struct OAuthResponseDataDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let profileComplete: Bool
    let user: UserDTO
}
