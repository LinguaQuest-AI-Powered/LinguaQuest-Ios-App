//
//  OAuthServiceError.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

/// Errors surfaced by the SDK wrapper layer (Google/Apple), before we ever
/// reach the backend. Kept separate from AuthError since these represent
/// client-side/SDK failures, not backend error keys.
enum OAuthServiceError: Error, Equatable {
    case missingPresentingViewController
    case missingIDToken
    case cancelled
    case firebaseSignInFailed
}
