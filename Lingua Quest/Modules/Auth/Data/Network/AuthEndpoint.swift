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


extension AuthEndpoint {
    struct SendOtp: Endpoint {
        let email: String
        let purpose: OtpPurpose

        var path: String { "/auth/otp/send" }
        var method: HTTPMethod { .post }
        var body: OtpSendRequestDTO? {
            OtpSendRequestDTO(email: email, purpose: purpose.rawValue)
        }
    }

    struct VerifySignupOtp: Endpoint {
        let email: String
        let otp: String

        var path: String { "/auth/otp/verify" }
        var method: HTTPMethod { .post }
        var body: OtpVerifyRequestDTO? {
            OtpVerifyRequestDTO(email: email, otp: otp)
        }
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
    }

    struct ResetPassword: Endpoint {
        let resetToken: String
        let newPassword: String

        var path: String { "/auth/forget-password" }
        var method: HTTPMethod { .patch }
        var body: ForgetPasswordRequestDTO? {
            ForgetPasswordRequestDTO(resetToken: resetToken, newPassword: newPassword)
        }
    }
}
