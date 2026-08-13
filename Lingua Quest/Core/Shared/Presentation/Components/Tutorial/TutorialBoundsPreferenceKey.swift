//
//  TutorialBoundsPreferenceKey.swift
//  Lingua Quest
//
//  Created by siam on 13/08/2026.
//

import SwiftUI

enum TutorialStepType: String, CaseIterable, Equatable {
    case learningProgress
    case currentLesson
    case coins
    case xp
    case notifications
    
    // Home Extra
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
                        value: [step: geo.frame(in: .named("TutorialSpace"))]
                    )
            }
        )
    }
}
