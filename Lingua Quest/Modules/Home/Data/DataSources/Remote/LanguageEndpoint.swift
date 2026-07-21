//
//  LanguageEndpoint.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

enum LanguageEndpoint {
    struct GetMyLanguages: Endpoint {
        var body: EmptyBody?
        var path: String { "/languages/mine" }
        var method: HTTPMethod { .get }
    }
    
    struct GetAvailableLanguages: Endpoint {
        var body: EmptyBody?
        var path: String { "/languages/available" }
        var method: HTTPMethod { .get }
    }
    
    struct SwitchActiveLanguage: Endpoint {
        let languageId: Int
        
        var path: String { "/languages/active" }
        var method: HTTPMethod { .patch }
        var body: SwitchLanguageRequestDTO? {
            SwitchLanguageRequestDTO(languageId: languageId)
        }
    }
    
    struct AddLanguage: Endpoint {
        let languageIds: [Int]
        
        var path: String { "/languages" }
        var method: HTTPMethod { .post }
        var body: AddLanguageRequestDTO? {
            AddLanguageRequestDTO(languageIds: languageIds)
        }
    }
}

struct SwitchLanguageRequestDTO: Encodable {
    let languageId: Int
}

struct AddLanguageRequestDTO: Encodable {
    let languageIds: [Int]
}
