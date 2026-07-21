//
//  AuthTokenProvider.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

/// Concrete implementation of Core's AuthTokenProviding, living in the Auth module
/// since it needs SecureTokenStorage + the Auth remote data source.
/// Talks to AuthRemoteDataSource directly (not through AuthRepositoryImpl/UseCase)
/// to keep this internal refresh path independent of the public Auth API surface.
final class AuthTokenProvider: AuthTokenProviding {
    private let tokenStorage: SecureTokenStorageProtocol
    private let remoteDataSource: AuthRemoteDataSourceProtocol

    /// Coalesces concurrent refresh attempts — if 3 requests 401 at once,
    /// we only want ONE actual call to /auth/refresh-token.
    private var inFlightRefresh: Task<Bool, Never>?

    init(tokenStorage: SecureTokenStorageProtocol, remoteDataSource: AuthRemoteDataSourceProtocol) {
        self.tokenStorage = tokenStorage
        self.remoteDataSource = remoteDataSource
    }

    func currentAccessToken() -> String? {
        tokenStorage.getAccessToken()
    }

    func refreshSession() async -> Bool {
        if let inFlightRefresh {
            return await inFlightRefresh.value
        }

        let task = Task<Bool, Never> { [tokenStorage, remoteDataSource] in
            guard let refreshToken = tokenStorage.getRefreshToken() else { return false }

            let result = await remoteDataSource.refreshToken(refreshToken: refreshToken)
            switch result {
            case .success(let session):
                tokenStorage.saveSession(accessToken: session.accessToken, refreshToken: session.refreshToken)
                return true
            case .failure:
                tokenStorage.clearSession()
                NotificationCenter.default.post(name: .sessionExpired, object: nil)
                return false
            }
        }

        inFlightRefresh = task
        let result = await task.value
        inFlightRefresh = nil
        return result
    }
}
