//
//  WalletEndpoint.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 25/07/2026.
//

import Foundation

enum WalletEndpoint {
    struct GetWallet: Endpoint {
        var path: String { "/wallet" }
        var method: HTTPMethod { .get }
        var body: EmptyBody? { nil }
        var cachePolicy: CachePolicy { .returnCacheDataElseLoad }
    }
    
    struct AdjustWallet: Endpoint {
        let xpDelta: Int
        let coinsDelta: Int
        
        var path: String { "/wallet/adjust" }
        var method: HTTPMethod { .post }
        var body: AdjustWalletRequestDTO? {
            AdjustWalletRequestDTO(xpDelta: xpDelta, coinsDelta: coinsDelta)
        }
    }
}
