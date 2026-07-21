//
//  HomeEndpoint.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

enum HomeEndpoint {
    struct GetHomeData: Endpoint {
        var body: EmptyBody?
        var path: String { "/home" }
        var method: HTTPMethod { .get }
    }
}
