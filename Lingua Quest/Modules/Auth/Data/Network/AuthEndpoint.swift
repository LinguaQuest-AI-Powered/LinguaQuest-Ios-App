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
        var requiresAuth: Bool { false }
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
        var requiresAuth: Bool { false }
    }
}

extension AuthEndpoint {
    struct SendOtp: Endpoint {
        let email: String
        let purpose: OtpPurpose

        var path: String { "/auth/otp/send" }
        var method: HTTPMethod { .post }
        var body: OtpSendRequestDTO? {
            OtpSendRequestDTO(email: email, purpose: purpose.rawValue)
        }
        var requiresAuth: Bool { false }
    }

    struct VerifySignupOtp: Endpoint {
        let email: String
        let otp: String

        var path: String { "/auth/otp/verify" }
        var method: HTTPMethod { .post }
        var body: OtpVerifyRequestDTO? {
            OtpVerifyRequestDTO(email: email, otp: otp)
        }
        var requiresAuth: Bool { false }
    }
}

extension AuthEndpoint {
    struct VerifyPasswordResetOtp: Endpoint {
        let email: String
        let otp: String

        var path: String { "/auth/forget-password/otp/verify" }
        var method: HTTPMethod { .post }
        var body: OtpVerifyRequestDTO? {
            OtpVerifyRequestDTO(email: email, otp: otp)
        }
        var requiresAuth: Bool { false }
    }

    struct ResetPassword: Endpoint {
        let resetToken: String
        let newPassword: String

        var path: String { "/auth/forget-password" }
        var method: HTTPMethod { .patch }
        var body: ForgetPasswordRequestDTO? {
            ForgetPasswordRequestDTO(resetToken: resetToken, newPassword: newPassword)
        }
        var requiresAuth: Bool { false }
    }
}

// MARK: - Token Management
extension AuthEndpoint {
    struct RefreshToken: Endpoint {
        let refreshToken: String

        var path: String { "/auth/refresh-token" }
        var method: HTTPMethod { .post }
        var body: RefreshTokenRequestDTO? {
            RefreshTokenRequestDTO(refreshToken: refreshToken)
        }
        var requiresAuth: Bool { false }
    }

    struct Logout: Endpoint {
        let refreshToken: String
        let allDevices: Bool

        var path: String { "/auth/logout" }
        var method: HTTPMethod { .post }
        var body: LogoutRequestDTO? {
            LogoutRequestDTO(refreshToken: refreshToken, allDevices: allDevices)
        }
        var requiresAuth: Bool { true }
    }
}
