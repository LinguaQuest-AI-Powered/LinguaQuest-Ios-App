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
    case gameLevels(worldId: Int, worldName: String)
    case cameraQuestTask
    case cameraCapture(targetWord: String)
    case cameraResult(targetWord: String)
    case leaderboard(languageId: Int)
    case achievements
    case wordInsight(word: WordCardEntity)
    case allWorlds
    case editProfile
}

enum AppSheet: String, Identifiable {
    // Add sheet routes here in the future
    case dummy // Added dummy to keep enum valid if needed
    var id: String { rawValue }
}
