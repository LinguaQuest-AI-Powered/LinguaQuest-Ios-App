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
    case login
    case onBoarding
    case signUp
    case forgetPassword
    case verifyEmail
    case resetPassword
    case gameLevels(worldName: String)
    case cameraQuestTask
    case cameraCapture(targetWord: String)
    case cameraResult(targetWord: String)
    case leaderboard
    case achievements
    case wordInsight(word: WordCardEntity)
}

enum AppSheet: String, Identifiable {
    case editProfile
    var id: String { rawValue }
}
