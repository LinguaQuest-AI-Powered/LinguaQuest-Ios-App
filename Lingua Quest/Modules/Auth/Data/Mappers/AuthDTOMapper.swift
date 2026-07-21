//
//  AuthDTOMapper.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

/// Converts remote DTOs into pure Domain entities. Nothing here ever leaks
/// outside the Data layer — the Repository only ever hands out Domain types.
enum AuthDTOMapper {
    static func mapLogin(_ dto: LoginResponseDataDTO) -> (session: AuthSessionEntity, user: UserEntity) {
        let session = AuthSessionEntity(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            tokenType: dto.tokenType,
            expiresIn: dto.expiresIn
        )
        let user = UserEntity(
            id: dto.user.id,
            username: dto.user.username,
            photo: dto.user.photo,
            nativeLanguage: dto.user.nativeLanguage,
            isVerified: dto.user.isVerified,
            targetLanguages: dto.user.targetLanguages
        )
        return (session, user)
    }

    /// Central place to turn a raw NetworkError into a typed AuthError by
    /// decoding the backend's error envelope out of NetworkError.serverError's payload.
    static func mapError(_ error: Error) -> AuthError {
        guard case let NetworkError.serverError(_, data) = error,
              let data,
              let envelope = try? JSONDecoder().decode(ErrorResponseDTO.self, from: data) else {
            return .unknown((error as? LocalizedError)?.errorDescription ?? "\(error)")
        }
        return AuthError.from(errorKey: envelope.error.errorKey, message: envelope.error.errorMessage)
    }
}


extension AuthDTOMapper {
    static func mapRegister(_ dto: RegisterResponseDataDTO) -> RegisteredAccountEntity {
        RegisteredAccountEntity(
            id: dto.id,
            email: dto.email,
            username: dto.username,
            nativeLanguage: dto.nativeLanguage,
            targetLanguage: dto.targetLanguage,
            isVerified: dto.isVerified
        )
    }
}


extension AuthDTOMapper {
    static func mapVerifySignupOtp(_ dto: VerifySignupOtpResponseDataDTO) -> Bool {
        dto.isVerified
    }
}

extension AuthDTOMapper {
    static func mapVerifyPasswordResetOtp(_ dto: VerifyPasswordResetOtpResponseDataDTO) -> (resetToken: String, expiresIn: Int) {
        (resetToken: dto.resetToken, expiresIn: dto.expiresIn)
    }
}

extension AuthDTOMapper {
    static func mapRefreshToken(_ dto: RefreshTokenResponseDataDTO) -> AuthSessionEntity {
        AuthSessionEntity(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            tokenType: dto.tokenType,
            expiresIn: dto.expiresIn
        )
    }
}
