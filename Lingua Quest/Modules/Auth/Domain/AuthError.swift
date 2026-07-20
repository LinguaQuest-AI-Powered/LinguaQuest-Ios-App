//
//  AuthError.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import Foundation

/// Maps 1:1 to the errorKey values documented in the API contract for the Auth module.
/// User-facing text is owned by us via L10n, NOT passed through from the backend —
/// backend errorMessage strings aren't guaranteed to stay stable or be user-appropriate.
enum AuthError: Error, Equatable {
    case validation(String)   // dynamic per-field message, no good static copy for it
    case invalidCredentials
    case emailNotVerified
    case emailAlreadyExists
    case usernameAlreadyTaken
    case emailNotFound
    case invalidOtp
    case otpNotFound
    case otpCooldown
    case maxOtpAttemptsExceeded
    case invalidResetToken
    case invalidRefreshToken
    case invalidFirebaseToken
    case unauthenticated
    case internalServerError
    case unknown(String)      // fallback only — raw backend message for logging/debugging

    /// Central place to translate a backend errorKey into a strongly-typed AuthError.
    static func from(errorKey: String, message: String) -> AuthError {
        switch errorKey {
        case "VALIDATION_ERROR": return .validation(message)
        case "INVALID_CREDENTIALS": return .invalidCredentials
        case "EMAIL_NOT_VERIFIED": return .emailNotVerified
        case "EMAIL_ALREADY_EXISTS": return .emailAlreadyExists
        case "USERNAME_ALREADY_EXISTS": return .usernameAlreadyTaken // TODO: confirm exact key with backend dev
        case "EMAIL_NOT_FOUND": return .emailNotFound
        case "INVALID_OTP": return .invalidOtp
        case "OTP_NOT_FOUND": return .otpNotFound
        case "OTP_COOLDOWN": return .otpCooldown
        case "MAX_ATTEMPTS_EXCEEDED": return .maxOtpAttemptsExceeded
        case "INVALID_RESET_TOKEN": return .invalidResetToken
        case "INVALID_REFRESH_TOKEN": return .invalidRefreshToken
        case "INVALID_FIREBASE_TOKEN": return .invalidFirebaseToken
        case "UNAUTHENTICATED": return .unauthenticated
        case "INTERNAL_SERVER_ERROR": return .internalServerError
        default: return .unknown(message)
        }
    }
}

extension AuthError: LocalizedError {
    /// Our own copy, not the backend's — keeps wording, tone, and language consistent
    /// with the rest of the app regardless of what the backend sends back.
    var errorDescription: String? {
        switch self {
        case .validation(let message): return message
        case .invalidCredentials: return L10n.Auth.Error.invalidCredentials
        case .emailNotVerified: return L10n.Auth.Error.emailNotVerified
        case .emailAlreadyExists: return L10n.Auth.Error.emailAlreadyExists
        case .usernameAlreadyTaken: return L10n.Auth.Error.usernameAlreadyTaken
        case .emailNotFound: return L10n.Auth.Error.emailNotFound
        case .invalidOtp: return L10n.Auth.Error.invalidOtp
        case .otpNotFound: return L10n.Auth.Error.otpNotFound
        case .otpCooldown: return L10n.Auth.Error.otpCooldown
        case .maxOtpAttemptsExceeded: return L10n.Auth.Error.maxOtpAttemptsExceeded
        case .invalidResetToken: return L10n.Auth.Error.invalidResetToken
        case .invalidRefreshToken: return L10n.Auth.Error.sessionExpired
        case .invalidFirebaseToken: return L10n.Auth.Error.invalidFirebaseToken
        case .unauthenticated: return L10n.Auth.Error.sessionExpired
        case .internalServerError: return L10n.Auth.Error.internalServerError
        case .unknown: return L10n.Auth.Error.generic
        }
    }
}
