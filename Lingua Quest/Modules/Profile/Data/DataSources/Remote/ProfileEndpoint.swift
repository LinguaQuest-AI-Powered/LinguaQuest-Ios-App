//
//  ProfileEndpoint.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

enum ProfileEndpoint {
    struct GetProfile: Endpoint {
        var path: String { "/profile" }
        var method: HTTPMethod { .get }
        var body: EmptyBody? { nil }
        var requiresAuth: Bool { true }
        var cachePolicy: CachePolicy { .returnCacheDataElseLoad }
    }
    
    struct CompleteProfile: Endpoint {
        let nativeLanguageId: Int
        let targetLanguageId: Int
        let username: String?
        
        var path: String { "/profile/complete-profile" }
        var method: HTTPMethod { .post }
        var body: CompleteProfileRequestDTO? {
            CompleteProfileRequestDTO(
                nativeLanguageId: nativeLanguageId,
                targetLanguageId: targetLanguageId,
                username: username
            )
        }
        var requiresAuth: Bool { true }
    }
    
    struct uploadPhoto: Endpoint {
        let data: Data
        let mimeType: String
        let boundary: String
        
        var path: String { "/profile/photo" }
        var method: HTTPMethod { .post }
        var body: EmptyBody? { nil }
        var requiresAuth: Bool { true }
        
        var headers: [String: String]? {
            var dict: [String: String] = [:]
            dict["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
            dict["Accept"] = "application/json"
            if requiresAuth, let token = SecureTokenStorage().getAccessToken() {
                dict["Authorization"] = "Bearer \(token)"
            }
            return dict
        }
        
        func asURLRequest() throws -> URLRequest {
            let components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            guard let url = components?.url else { throw NetworkError.invalidURL }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            var bodyData = Foundation.Data()
            let crlf = "\r\n"
            let filename = mimeType == "image/png" ? "photo.png" : "photo.jpg"
            
            bodyData.append(contentsOf: "--\(boundary)\(crlf)".utf8)
            bodyData.append(contentsOf: "Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\(crlf)".utf8)
            bodyData.append(contentsOf: "Content-Type: \(mimeType)\(crlf)\(crlf)".utf8)
            bodyData.append(data)
            bodyData.append(contentsOf: "\(crlf)".utf8)
            bodyData.append(contentsOf: "--\(boundary)--\(crlf)".utf8)
            
            request.httpBody = bodyData
            return request
        }
    }
    
    struct updateProfile: Endpoint {
        let username: String
        
        var path: String { "/profile" }
        var method: HTTPMethod { .patch }
        var body: UpdateProfileRequestDTO? {
            UpdateProfileRequestDTO(username: username)
        }
        var requiresAuth: Bool { true }
    }
    
    struct ChangePassword: Endpoint {
        let oldPassword: String
        let newPassword: String

        var path: String { "/profile/password" }
        var method: HTTPMethod { .patch }
        var body: ChangePasswordRequestDTO? {
            ChangePasswordRequestDTO(oldPassword: oldPassword, newPassword: newPassword)
        }
        var requiresAuth: Bool { true }
    }

    // MARK: - Achievements
    struct GetAchievements: Endpoint {
        let status: String
        var path: String { "/achievements" }
        var method: HTTPMethod { .get }
        var body: EmptyBody? { nil }
        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "status", value: status)]
        }
        var cachePolicy: CachePolicy { .returnCacheDataElseLoad }
    }
    
    struct GetWeeklyReward: Endpoint {
        var path: String { "/achievements/weekly-reward" }
        var method: HTTPMethod { .get }
        var body: EmptyBody? { nil }
        var cachePolicy: CachePolicy { .returnCacheDataElseLoad }
    }
    
    struct ClaimWeeklyReward: Endpoint {
        var path: String { "/achievements/weekly-reward/claim" }
        var method: HTTPMethod { .post }
        var body: EmptyBody? { nil }
    }
    
    // MARK: - Leaderboard
    struct GetLeaderboard: Endpoint {
        let scope: String
        let languageId: Int
        let page: Int
        let limit: Int
        
        var path: String { "/leaderboard" }
        var method: HTTPMethod { .get }
        var body: EmptyBody? { nil }
        var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "scope", value: scope),
                URLQueryItem(name: "languageId", value: "\(languageId)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
        var cachePolicy: CachePolicy { .returnCacheDataElseLoad }
    }
}

