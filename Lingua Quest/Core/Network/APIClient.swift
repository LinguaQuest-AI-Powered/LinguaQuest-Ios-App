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
        let urlRequest = try endpoint.asURLRequest()
        
        // --- LOGGING REQUEST ---
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
            print("======== [API ERROR] ========")
            print("Network Error: \(error.localizedDescription)")
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
        case 200...299: break
        default: throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("======== [API DECODING ERROR] ========")
            print("Error: \(error)")
            print("======================================")
            throw NetworkError.decodingFailed(error)
        }
    }
}
