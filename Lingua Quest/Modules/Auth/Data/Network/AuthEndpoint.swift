//
//  AuthEndpoint.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

enum AuthEndpoint {
    struct Login: Endpoint {
        let email: String
        let password: String

        var path: String { "/auth/login" }
        var method: HTTPMethod { .post }
        var body: LoginRequestDTO? { LoginRequestDTO(email: email, password: password) }
    }
}

extension AuthEndpoint {
    struct Register: Endpoint {
        let email: String
        let username: String
        let password: String
        let nativeLanguage: String
        let targetLanguage: String

        var path: String { "/auth/register" }
        var method: HTTPMethod { .post }
        var body: RegisterRequestDTO? {
            RegisterRequestDTO(
                email: email, username: username, password: password,
                nativeLanguage: nativeLanguage, targetLanguage: targetLanguage
            )
        }
    }
}
