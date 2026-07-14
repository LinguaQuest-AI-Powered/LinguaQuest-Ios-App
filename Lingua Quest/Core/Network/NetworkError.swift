//
//  NetworkError.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noConnection
    case decodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case unauthorized
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return L10n.Network.invalidURL
        case .noConnection:
            return L10n.Network.noConnection
        case .decodingFailed:
            return L10n.Network.decodingFailed
        case .serverError(let code, _):
            return L10n.Network.serverError(statusCode: code)
        case .unauthorized:
            return L10n.Network.unauthorized
        case .unknown:
            return L10n.Network.unknown
        }
    }
}
