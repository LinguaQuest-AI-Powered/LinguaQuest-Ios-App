//
//  AuthRepositoryImpl.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepositoryProtocol {
    
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let tokenStorage: SecureTokenStorageProtocol

    init(remoteDataSource: AuthRemoteDataSourceProtocol, tokenStorage: SecureTokenStorageProtocol) {
        self.remoteDataSource = remoteDataSource
        self.tokenStorage = tokenStorage
    }
    
    
    // MARK: - Implemented Methods
    
    func register(email: String, username: String, password: String, nativeLanguage: String, targetLanguage: String) async -> Result<RegisteredAccountEntity, AuthError> {
        await remoteDataSource.register(
            email: email, username: username, password: password,
            nativeLanguage: nativeLanguage, targetLanguage: targetLanguage
        )
    }
    
    
    func login(email: String, password: String) async -> Result<(session: AuthSessionEntity, user: UserEntity), AuthError> {
        let result = await remoteDataSource.login(email: email, password: password)
        if case let .success((session, _)) = result {
            tokenStorage.saveSession(accessToken: session.accessToken, refreshToken: session.refreshToken)
        }
        return result
    }
    
    func logout(refreshToken: String, allDevices: Bool) async -> Result<Void, AuthError> {
        let result = await remoteDataSource.logout(refreshToken: refreshToken, allDevices: allDevices)
        // Logout is idempotent per the contract — clear local state regardless of
        // the backend outcome (e.g. an already-revoked token shouldn't block local sign-out).
        tokenStorage.clearSession()
        switch result {
        case .success:
            return .success(())
        case .failure:
            return .success(())
        }
    }
    
    func refreshToken(refreshToken: String) async -> Result<AuthSessionEntity, AuthError> {
        let result = await remoteDataSource.refreshToken(refreshToken: refreshToken)
        if case let .success(session) = result {
            tokenStorage.saveSession(accessToken: session.accessToken, refreshToken: session.refreshToken)
        }
        return result
    }
    
    func sendOtp(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError> {
        await remoteDataSource.sendOtp(email: email, purpose: purpose)
    }

    func verifySignupOtp(email: String, otp: String) async -> Result<Bool, AuthError> {
        await remoteDataSource.verifySignupOtp(email: email, otp: otp)
    }
    
    func verifyPasswordResetOtp(email: String, otp: String) async -> Result<(resetToken: String, expiresIn: Int), AuthError> {
        await remoteDataSource.verifyPasswordResetOtp(email: email, otp: otp)
    }

    func resetPassword(resetToken: String, newPassword: String) async -> Result<Void, AuthError> {
        let result = await remoteDataSource.resetPassword(resetToken: resetToken, newPassword: newPassword)
        if case .success = result {
            // Per contract: successful reset invalidates all refresh tokens (forces re-login everywhere),
            // so we clear the locally stored session too, keeping local state consistent with the backend.
            tokenStorage.clearSession()
        }
        return result
    }
    
    func loginWithFirebase(idToken: String) async -> Result<(session: AuthSessionEntity, user: UserEntity, profileComplete: Bool), AuthError> {
        fatalError("loginWithFirebase() has not been implemented yet")
    }
    
    
}
