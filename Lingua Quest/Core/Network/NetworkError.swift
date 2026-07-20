//
//  NetworkError.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import  Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noConnection
    case encodingFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return L10n.Network.invalidURL
        case .noConnection: return L10n.Network.noConnection
        case .encodingFailed: return L10n.Network.encodingFailed
        case .decodingFailed: return L10n.Network.decodingFailed
        case .serverError(let code, _): return L10n.Network.serverError(statusCode: code)
        case .unknown: return L10n.Network.unknown
        }
    }
}
