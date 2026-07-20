//
//  OtpDTOs.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

struct OtpSendRequestDTO: Encodable {
    let email: String
    let purpose: String
}

struct OtpVerifyRequestDTO: Encodable {
    let email: String
    let otp: String
}

/// Generic { "status": "success" } payload used by /auth/otp/send.
struct StatusResponseDataDTO: Decodable {
    let status: String
}

struct VerifySignupOtpResponseDataDTO: Decodable {
    let isVerified: Bool
}
