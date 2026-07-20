//
//  PasswordResetDTOs.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

struct VerifyPasswordResetOtpResponseDataDTO: Decodable {
    let resetToken: String
    let expiresIn: Int
}

struct ForgetPasswordRequestDTO: Encodable {
    let resetToken: String
    let newPassword: String
}
