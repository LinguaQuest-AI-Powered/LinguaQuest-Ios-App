//
//  ProfileEndpoint.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

enum ProfileEndpoint: Endpoint {
    case getProfile
    case uploadPhoto(data: Data, mimeType: String, boundary: String)
    case updateProfile(username: String)
    
    var path: String {
        switch self {
        case .getProfile, .updateProfile:
            return "/profile"
        case .uploadPhoto:
            return "/profile/photo"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        case .uploadPhoto:
            return .post
        case .updateProfile:
            return .patch
        }
    }
    
    var headers: [String: String]? {
        var dict: [String: String] = [:]
        switch self {
        case .getProfile, .updateProfile:
            dict["Content-Type"] = "application/json"
        case .uploadPhoto(_, _, let boundary):
            dict["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        }
        dict["Accept"] = "application/json"
        
        if requiresAuth, let token = SecureTokenStorage().getAccessToken() {
            dict["Authorization"] = "Bearer \(token)"
        }
        return dict
    }

    var body: EmptyBody? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .uploadPhoto(let data, let mimeType, let boundary):
            let components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            guard let url = components?.url else { throw NetworkError.invalidURL }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            var customHeaders = headers ?? [:]
            customHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
            request.allHTTPHeaderFields = customHeaders
            
            var body = Data()
            let filename = mimeType == "image/png" ? "photo.png" : "photo.jpg"
            
            // Direct UTF-8 appending to ensure byte data accuracy without memory overhead or parsing errors
            let crlf = "\r\n"
            
            body.append(contentsOf: "--\(boundary)\(crlf)".utf8)
            body.append(contentsOf: "Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\(crlf)".utf8)
            body.append(contentsOf: "Content-Type: \(mimeType)\(crlf)\(crlf)".utf8)
            body.append(data)
            body.append(contentsOf: "\(crlf)".utf8)
            body.append(contentsOf: "--\(boundary)--\(crlf)".utf8)
            
            request.httpBody = body
            return request

        default:
            var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            
            guard let url = components?.url else { throw NetworkError.invalidURL }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            // updateProfile sends a JSON body
            if case .updateProfile(let username) = self {
                let dto = UpdateProfileRequestDTO(username: username)
                request.httpBody = try JSONEncoder().encode(dto)
            }
            
            return request
        }
    }
}
