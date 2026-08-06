//
//  GameEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

enum GameEndpoint {
    struct ContinueLevel: Endpoint {
        var body: EmptyBody?
        
        var path: String { "/worlds/continue-level" }
        var method: HTTPMethod { .get }
    }
    
    struct Levels: Endpoint {
        var body: EmptyBody?
        
        let worldId: Int
        let languageId: Int

        var path: String { "/worlds/\(worldId)/levels" }
        var method: HTTPMethod { .get }
        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "languageId", value: String(languageId))]
        }
    }
    
    struct StartLevel: Endpoint {
        var body: EmptyBody?
        let worldId: Int
        let levelId: Int
        
        var path: String { "/worlds/\(worldId)/levels/\(levelId)/start" }
        var method: HTTPMethod { .post }
    }
    
    struct ChangeWord: Endpoint {
        var body: EmptyBody?
        let worldId: Int
        let levelId: Int
        
        var path: String { "/worlds/\(worldId)/levels/\(levelId)/change-word" }
        var method: HTTPMethod { .put }
    }
    
    struct GetHint: Endpoint {
        var body: EmptyBody?
        let worldId: Int
        let levelId: Int
        
        var path: String { "/worlds/\(worldId)/levels/\(levelId)/hint" }
        var method: HTTPMethod { .get }
    }
    
    struct VerifyImage: Endpoint {
        var body: EmptyBody?
        let worldId: Int
        let levelId: Int
        let imageData: Data
        
        var path: String { "/worlds/\(worldId)/levels/\(levelId)/verify" }
        var method: HTTPMethod { .post }
        
        // Override asURLRequest to support multipart/form-data
        func asURLRequest() throws -> URLRequest {
            var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
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
            
            bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = bodyData
            
            return request
        }
    }
}
