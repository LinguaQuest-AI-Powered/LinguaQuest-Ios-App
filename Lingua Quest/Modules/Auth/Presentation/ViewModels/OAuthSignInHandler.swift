//
//  OAuthSignInHandler.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import Foundation

enum OAuthProviderType {
    case google
    case apple
}

enum OAuthSignInResult {
    case success
    case failure(message: String)
}

protocol OAuthSignInHandlerProtocol {
    func handleSignIn(provider: OAuthProviderType) async -> OAuthSignInResult
}

final class OAuthSignInHandler: OAuthSignInHandlerProtocol {
    private let googleSignInService: GoogleSignInServiceProtocol
    private let appleSignInService: AppleSignInServiceProtocol
    private let firebaseLoginUseCase: FirebaseLoginUseCaseProtocol
    private var userPreferences: UserPreferencesProtocol

    init(
        googleSignInService: GoogleSignInServiceProtocol,
        appleSignInService: AppleSignInServiceProtocol,
        firebaseLoginUseCase: FirebaseLoginUseCaseProtocol,
        userPreferences: UserPreferencesProtocol
    ) {
        self.googleSignInService = googleSignInService
        self.appleSignInService = appleSignInService
        self.firebaseLoginUseCase = firebaseLoginUseCase
        self.userPreferences = userPreferences
    }

    func handleSignIn(provider: OAuthProviderType) async -> OAuthSignInResult {
        do {
            let idToken: String
            switch provider {
            case .google:
                idToken = try await googleSignInService.signIn()
            case .apple:
                idToken = try await appleSignInService.signIn()
            }

            let result = await firebaseLoginUseCase.execute(idToken: idToken)

            switch result {
            case .success(let (_, _, profileComplete)):
                userPreferences.isLoggedIn = true
                if !profileComplete {
                    userPreferences.needsProfileCompletion = true
                }
                return .success

            case .failure(let error):
                return .failure(message: error.errorDescription ?? L10n.Auth.Error.generic)
            }
        } catch is OAuthServiceError {
            return .failure(message: L10n.Auth.Error.oauthCancelledOrFailed)
        } catch {
            return .failure(message: L10n.Auth.Error.generic)
        }
    }
}
