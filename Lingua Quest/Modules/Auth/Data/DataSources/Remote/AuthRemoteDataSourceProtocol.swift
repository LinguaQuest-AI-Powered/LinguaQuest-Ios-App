//
//  AuthRemoteDataSourceProtocol.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol AuthRemoteDataSourceProtocol {
    func login(email: String, password: String) async -> Result<(session: AuthSessionEntity, user: UserEntity), AuthError>
    func register(
        email: String, username: String, password: String,
        nativeLanguage: String, targetLanguage: String
    ) async -> Result<RegisteredAccountEntity, AuthError>
}
