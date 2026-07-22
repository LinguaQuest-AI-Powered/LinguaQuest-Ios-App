//
//  Endpoint.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Foundation

/// Used by endpoints that don't send a body (GET requests, etc.)
struct EmptyBody: Encodable {}

protocol Endpoint {
    associatedtype Body: Encodable = EmptyBody

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Body? { get }
    /// Whether this request needs `Authorization: Bearer <token>`.
    /// Defaults to true per the API contract ("all endpoints outside /auth/** require authentication").
    /// Auth endpoints that don't need it explicitly override this to false.
    var requiresAuth: Bool { get }
}

extension Endpoint {
    var baseURL: URL { AppConfig.baseURL }
    var headers: [String: String]? {
        var dict = ["Content-Type": "application/json"]
        if requiresAuth {
            // The mock server requires a Bearer token.
            // We use the actual token if available, otherwise a dummy token to satisfy the mock server's OpenAPI validation.
            let token = SecureTokenStorage().getAccessToken() ?? "dummy_mock_token"
            dict["Authorization"] = "Bearer \(token)"
        }
        return dict
    }
    var queryItems: [URLQueryItem]? { nil }
    var requiresAuth: Bool { true }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems

        guard let url = components?.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        if let body {
            do {
                // No key strategy: API contract uses camelCase, matching our DTO property names as-is.
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encodingFailed(error)
            }
        }
        return request
    }
}
