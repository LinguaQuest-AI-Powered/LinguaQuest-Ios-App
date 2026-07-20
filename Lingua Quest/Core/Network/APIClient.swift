//
//  APIClient.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Foundation

protocol APIClientProtocol {
    func request<E: Endpoint, T: Decodable>(_ endpoint: E) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    /// Set after DI wiring completes (see Resolver.swift) to break the circular
    /// dependency between APIClient <-> AuthTokenProvider <-> AuthRemoteDataSource.
    /// Weak because the container (not APIClient) owns the provider's lifetime.
    weak var tokenProvider: AuthTokenProviding?

    init(session: URLSession = .shared, decoder: JSONDecoder = APIClient.defaultDecoder) {
        self.session = session
        self.decoder = decoder
    }

    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    
    func request<E: Endpoint, T: Decodable>(_ endpoint: E) async throws -> T {
        try await performRequest(endpoint, isRetryAfterRefresh: false)
    }

    private func performRequest<E: Endpoint, T: Decodable>(_ endpoint: E, isRetryAfterRefresh: Bool) async throws -> T {
        var urlRequest = try endpoint.asURLRequest()

        if endpoint.requiresAuth, let token = tokenProvider?.currentAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkError.noConnection
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }

        switch httpResponse.statusCode {
        case 200...299:
            break

        case 401 where endpoint.requiresAuth && !isRetryAfterRefresh:
            // Access token likely expired — try a silent refresh, then retry once.
            let refreshed = await tokenProvider?.refreshSession() ?? false
            guard refreshed else {
                throw NetworkError.serverError(statusCode: 401, data: data)
            }
            return try await performRequest(endpoint, isRetryAfterRefresh: true)

        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
