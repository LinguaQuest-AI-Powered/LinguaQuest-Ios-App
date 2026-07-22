//
//  GoogleSignInService.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

protocol GoogleSignInServiceProtocol {
    /// Runs the full Google -> Firebase exchange and returns a Firebase ID token,
    /// which is what the backend's /auth/oauth/firebase endpoint expects
    /// (it verifies via Firebase Admin SDK, not Google's raw token).
    @MainActor
    func signIn() async throws -> String
}

final class GoogleSignInService: GoogleSignInServiceProtocol {
    @MainActor
    func signIn() async throws -> String {
        guard let presentingVC = Self.topViewController() else {
            throw OAuthServiceError.missingPresentingViewController
        }

        let googleResult: GIDSignInResult
        do {
            googleResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
        } catch {
            throw OAuthServiceError.cancelled
        }

        guard let googleIDToken = googleResult.user.idToken?.tokenString else {
            throw OAuthServiceError.missingIDToken
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: googleIDToken,
            accessToken: googleResult.user.accessToken.tokenString
        )

        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            return try await authResult.user.getIDToken()
        } catch {
            throw OAuthServiceError.firebaseSignInFailed
        }
    }

    @MainActor
    private static func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let root = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else {
            return nil
        }
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}
