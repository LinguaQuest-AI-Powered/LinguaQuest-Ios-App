//
//  ProfileEndpoint.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

enum ProfileEndpoint {
    struct GetProfile: Endpoint {
        var path: String { "/profile" }
        var method: HTTPMethod { .get }
        var body: EmptyBody? { nil }
        var requiresAuth: Bool { true }
    }
    
    struct CompleteProfile: Endpoint {
        let nativeLanguageId: Int
        let targetLanguageId: Int
        let username: String?
        
        var path: String { "/profile/complete-profile" }
        var method: HTTPMethod { .post }
        var body: CompleteProfileRequestDTO? {
            CompleteProfileRequestDTO(
                nativeLanguageId: nativeLanguageId,
                targetLanguageId: targetLanguageId,
                username: username
            )
        }
        var requiresAuth: Bool { true }
    }
}

