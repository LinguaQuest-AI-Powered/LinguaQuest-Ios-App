//
//  ProfileEndpoint.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

enum ProfileEndpoint: Endpoint {
    case getProfile
    
    var path: String {
        switch self {
        case .getProfile:
            return "/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        }
    }
    
    var body: EmptyBody? {
        return nil
    }
}
