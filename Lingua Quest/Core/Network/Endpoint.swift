//
//  Endpoint.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var baseURL: URL { AppConfig.baseURL }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var queryItems: [URLQueryItem]? { nil }
    var body: [String: Any]? { nil }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems

        guard let url = components?.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        if let body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        return request
    }
}

