//
//  TutorialBoundsPreferenceKey.swift
//  Lingua Quest
//
//  Created by siam on 13/08/2026.
//

import SwiftUI

enum TutorialStepType: String, CaseIterable, Equatable {
    case dailyReward
    //  Home Extra
    case xp
    case coins
    case notifications
    case learningProgress
    case currentLesson
    case exploreWorlds
    case switchLanguage
    
    // Gallery
    case gameCaptures
    case myJournal
    
    // Lingos
    case voicePractice
    case roleplay
    case mindReader
    
    // Profile
    case yourProfile
    case profileStats
    case settings
    case achievements
    case leaderboard
}

struct TutorialBoundsPreferenceKey: PreferenceKey {
    static var defaultValue: [TutorialStepType: CGRect] = [:]
    
    static func reduce(value: inout [TutorialStepType: CGRect], nextValue: () -> [TutorialStepType: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}

extension View {
    func tutorialStep(_ step: TutorialStepType) -> some View {
        self.background(
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: TutorialBoundsPreferenceKey.self,
                        value: [step: geo.frame(in: .global)]
                    )
            }
        )
    }
}

struct CurrentTutorialStepKey: EnvironmentKey {
    static let defaultValue: TutorialStepType? = nil
}

extension EnvironmentValues {
    var currentTutorialStep: TutorialStepType? {
        get { self[CurrentTutorialStepKey.self] }
        set { self[CurrentTutorialStepKey.self] = newValue }
    }
}
