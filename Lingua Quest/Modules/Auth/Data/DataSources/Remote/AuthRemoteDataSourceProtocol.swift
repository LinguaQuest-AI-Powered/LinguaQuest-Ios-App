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
    func sendOtp(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError>
    func verifySignupOtp(email: String, otp: String) async -> Result<Bool, AuthError>
    func verifyPasswordResetOtp(email: String, otp: String) async -> Result<(resetToken: String, expiresIn: Int), AuthError>
    func resetPassword(resetToken: String, newPassword: String) async -> Result<Void, AuthError>
    func refreshToken(refreshToken: String) async -> Result<AuthSessionEntity, AuthError>
    func logout(refreshToken: String, allDevices: Bool) async -> Result<Void, AuthError>
    func loginWithFirebase(idToken: String) async -> Result<(session: AuthSessionEntity, user: UserEntity, profileComplete: Bool), AuthError>
}
