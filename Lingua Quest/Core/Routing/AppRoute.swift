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
    case completeProfile
    case signUp
    case forgetPassword
    case verifyEmail(email: String)
    case verifyPasswordResetOtp(email: String)
    case resetPassword(resetToken: String)
    case gameLevels(worldId: Int, worldName: String, languageId: Int)
    case cameraQuestTask(worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String)
    case voiceGame
    case cameraCapture(worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String)
    case cameraResult(worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String, imageData: Data?)
    case voiceGameResult(audioData: Data, sentence: VoiceSentence)
    case leaderboard(languageId: Int)
    case achievements
    case wordInsight(word: WordCardEntity)
    case allWorlds
    case editProfile
    case bossLevel(scenarioTitle: String)
    case roleplayScenarios
    case mindReaderIntro
    case mindReaderGame
    case appLanguageSelection
    case about
    case helpAndSupport
}

enum AppSheet: String, Identifiable {
    // Add sheet routes here in the future
    case dummy // Added dummy to keep enum valid if needed
    var id: String { rawValue }
}
