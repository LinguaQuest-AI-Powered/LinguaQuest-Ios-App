//
//  AppConfig.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//
import Foundation

enum AppConfig {
    
    static var baseURL: URL {
        let host = string(for: .apiBaseURL).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let urlString = host.hasPrefix("http") ? host : "https://" + host
        
        print("🚀 READ URL STRING: '\(urlString)'")
        
        guard let url = URL(string: urlString) else {
            preconditionFailure(
                "The value of \(Key.apiBaseURL.rawValue) in Info.plist is not a valid URL ('\(urlString)') — check Config/Config.xcconfig"
            )
        }
        return url
    }
    
    static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    static var aiKey: String {
        string(for: .aiKey).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static var aiBaseURL: URL {
        let host = string(for: .aiBaseURL).trimmingCharacters(in: .whitespacesAndNewlines)
        let urlString = host.hasPrefix("http") ? host : "https://" + host
        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid URL for AI_BASE_URL: \(urlString)")
        }
        return url
    }
    
    private enum Key: String {
        case apiBaseURL = "API_BASE_URL"
        case aiKey = "AI_KEY"
        case aiBaseURL = "AI_BASE_URL"
    }
    
    private static func string(for key: Key) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String,
            !value.isEmpty
        else {
            preconditionFailure(
                """
                The value \(key.rawValue) is missing in Info.plist.
                Make sure to:
                1) Add \(key.rawValue) in your local Config/Config.xcconfig.
                2) Add \(key.rawValue) as a Key in Info.plist with the value $(\(key.rawValue)).
                """
            )
        }
        return value
    }
}
