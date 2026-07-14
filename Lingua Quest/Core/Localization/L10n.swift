//
//  L10n.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Foundation

enum L10n {

    enum Network {
        static var invalidURL: String { localized("network.error.invalid_url") }
        static var noConnection: String { localized("network.error.no_connection") }
        static var decodingFailed: String { localized("network.error.decoding_failed") }
        static var unauthorized: String { localized("network.error.unauthorized") }
        static var unknown: String { localized("network.error.unknown") }
        static func serverError(statusCode: Int) -> String {
            String(format: localized("network.error.server_error"), statusCode)
        }
    }

    enum Common {
        static var retry: String { localized("common.retry") }
        static var cancel: String { localized("common.cancel") }
        static var ok: String { localized("common.ok") }
    }

    enum Auth {
        static var emailPlaceholder: String { localized("auth.email_placeholder") }
        static var passwordPlaceholder: String { localized("auth.password_placeholder") }
        static var continueWithGoogle: String { localized("auth.continue_google") }
        static var continueWithApple: String { localized("auth.continue_apple") }
    }
    
    enum Components {
        static var appName: String { localized("components.app_name") }
    }

    private static func localized(_ key: String) -> String {
        return String(localized: String.LocalizationValue(key))
        }
}
