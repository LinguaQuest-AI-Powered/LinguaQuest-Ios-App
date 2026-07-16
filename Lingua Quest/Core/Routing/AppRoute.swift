//
//  AppRoute.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

enum AppRoute: Hashable {
    case home
    case profile(userId: String)
    case settings
    case productDetails(id: String)
    case login
    case signUp
    case forgetPassword
    case verifyEmail
    case resetPassword
}

enum AppSheet: String, Identifiable {
    case editProfile
    var id: String { rawValue }
}
