//
//  AppleSignInService.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import UIKit

protocol AppleSignInServiceProtocol {
    @MainActor
    func signIn() async throws -> String
}

/// Wraps ASAuthorizationController's delegate-based API in async/await.
/// A raw nonce is required by Firebase for replay-attack protection: we send
/// its SHA256 hash to Apple, and the raw value to Firebase alongside Apple's
/// signed identity token.
final class AppleSignInService: NSObject, AppleSignInServiceProtocol {
    private var currentNonce: String?
    private var continuation: CheckedContinuation<String, Error>?

    @MainActor
    func signIn() async throws -> String {
        guard continuation == nil else {
            throw OAuthServiceError.cancelled
        }
        
        let nonce = Self.randomNonceString()
        currentNonce = nonce

        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = Self.sha256(nonce)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            controller.performRequests()
        }
    }

    // MARK: - Nonce helpers
    private static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        precondition(status == errSecSuccess, "Unable to generate secure nonce")

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(randomBytes.map { charset[Int($0) % charset.count] })
    }

    private static func sha256(_ input: String) -> String {
        SHA256.hash(data: Data(input.utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
}

extension AppleSignInService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let identityTokenData = appleIDCredential.identityToken,
              let identityTokenString = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: OAuthServiceError.missingIDToken)
            continuation = nil
            return
        }

        let credential = OAuthProvider.appleCredential(
            withIDToken: identityTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Task {
            do {
                let authResult = try await Auth.auth().signIn(with: credential)
                let firebaseIDToken = try await authResult.user.getIDToken()
                continuation?.resume(returning: firebaseIDToken)
            } catch {
                continuation?.resume(throwing: OAuthServiceError.firebaseSignInFailed)
            }
            continuation = nil
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let mappedError: Error = (error as? ASAuthorizationError)?.code == .canceled
            ? OAuthServiceError.cancelled
            : error
        continuation?.resume(throwing: mappedError)
        continuation = nil
    }
}

extension AppleSignInService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let windowScene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
        
        if let windowScene = windowScene {
            return windowScene.windows.first(where: \.isKeyWindow) ?? ASPresentationAnchor(windowScene: windowScene)
        }
        return UIWindow()
    }
}
