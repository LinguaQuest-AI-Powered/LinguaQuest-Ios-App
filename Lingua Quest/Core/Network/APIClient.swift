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

        // --- LOGGING REQUEST
        print("======== [API REQUEST] ========")
        print("URL: \(urlRequest.url?.absoluteString ?? "N/A")")
        print("METHOD: \(urlRequest.httpMethod ?? "N/A")")
        if let headers = urlRequest.allHTTPHeaderFields {
            print("HEADERS: \(headers)")
        }
        if let bodyData = urlRequest.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("BODY: \(bodyString)")
        }
        print("===============================")
        // -------------------------------

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            // --- LOGGING ERROR ---
            print("======== [API ERROR] ========")
            print("Network Error: \(error.localizedDescription)")
            print("Actual Error: \(error as NSError)")
            print("=============================")
            throw NetworkError.noConnection
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }

        // --- LOGGING RESPONSE ---
        print("======== [API RESPONSE] ========")
        print("URL: \(httpResponse.url?.absoluteString ?? "N/A")")
        print("STATUS CODE: \(httpResponse.statusCode)")
        if let responseString = String(data: data, encoding: .utf8) {
            print("DATA: \(responseString)")
        } else {
            print("DATA: Unable to parse data to string")
        }
        print("================================")
        // --------------------------------

        switch httpResponse.statusCode {
        case 200...299:
            break

        case 401 where endpoint.requiresAuth && !isRetryAfterRefresh:
            // Access token likely expired — try a silent refresh, then retry once.
            print("⚠️ [API] 401 Unauthorized. Attempting Silent Refresh...")
            let refreshed = await tokenProvider?.refreshSession() ?? false
            guard refreshed else {
                print("❌ [API] Silent Refresh Failed. User must re-login.")
                throw NetworkError.serverError(statusCode: 401, data: data)
            }
            print("✅ [API] Silent Refresh Succeeded. Retrying original request...")
            return try await performRequest(endpoint, isRetryAfterRefresh: true)

        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            // --- LOGGING DECODING ERROR ---
            print("======== [API DECODING ERROR] ========")
            print("Error: \(error)")
            print("======================================")
            throw NetworkError.decodingFailed(error)
        }
    }
}
