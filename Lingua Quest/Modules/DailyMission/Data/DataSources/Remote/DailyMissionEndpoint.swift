//
//  DailyMissionEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation

enum DailyMissionEndpoint {
    struct GetMission: Endpoint {
        var body: EmptyBody?
        var path: String { "/missions" }
        var method: HTTPMethod { .get }
    }

    struct VerifyMission: Endpoint {
        var body: EmptyBody?
        let imageData: Data
        let word: String

        var path: String { "/missions/verify" }
        var method: HTTPMethod { .post }

        // Override asURLRequest to support multipart/form-data with image + word fields
        func asURLRequest() throws -> URLRequest {
            var components = URLComponents(
                url: baseURL.appendingPathComponent(path),
                resolvingAgainstBaseURL: false
            )
            guard let url = components?.url else { throw NetworkError.invalidURL }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue

            let boundary = UUID().uuidString
            var customHeaders = headers ?? [:]
            customHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
            request.allHTTPHeaderFields = customHeaders

            var bodyData = Data()

            // Image part
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            bodyData.append(imageData)
            bodyData.append("\r\n".data(using: .utf8)!)

            // Word part
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"word\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append(word.data(using: .utf8)!)
            bodyData.append("\r\n".data(using: .utf8)!)

            bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = bodyData

            return request
        }
    }
}
