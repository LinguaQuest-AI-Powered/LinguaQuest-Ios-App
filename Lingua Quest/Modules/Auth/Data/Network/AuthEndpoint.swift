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
