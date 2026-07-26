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

struct APIErrorDetail: Decodable {
    let errorCode: Int?
    let errorKey: String?
    let errorMessage: String?
}

struct APIErrorResponse: Decodable {
    let success: Bool?
    let error: APIErrorDetail?
}

extension NetworkError {
    var apiErrorMessage: String? {
        if case .serverError(_, let data) = self,
           let data = data,
           let response = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
            return response.error?.errorMessage
        }
        return nil
    }
}
