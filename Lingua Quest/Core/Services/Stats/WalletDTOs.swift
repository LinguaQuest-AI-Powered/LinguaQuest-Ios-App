//
//  WalletDTOs.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 25/07/2026.
//

import Foundation

struct WalletResponseDTO: Decodable {
    let success: Bool
    let data: WalletDataDTO
}

struct WalletDataDTO: Decodable {
    let xp: Int?
    let coins: Int?
}

struct AdjustWalletResponseDTO: Decodable {
    let success: Bool
    let data: AdjustWalletDataDTO
}

struct AdjustWalletDataDTO: Decodable {
    let xpDelta: Int?
    let coinsDelta: Int?
    let xp: Int?
    let coins: Int?
}

struct AdjustWalletRequestDTO: Encodable {
    let xpDelta: Int
    let coinsDelta: Int
}
