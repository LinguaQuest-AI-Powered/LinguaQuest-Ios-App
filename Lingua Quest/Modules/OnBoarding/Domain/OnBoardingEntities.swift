//
//  OnBoardingEntities.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation
import SwiftUI

enum OnboardingStep {
    case welcome
    case language
    case level
}

struct Language: Identifiable, Equatable {
    let id = UUID()
    let code: String
    let name: String
    let flag: ImageResource
}

enum UserLevel: String, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner: return L10n.Onboarding.beginnerTitle
        case .intermediate: return L10n.Onboarding.intermediateTitle
        case .advanced: return L10n.Onboarding.advancedTitle
        }
    }

    var subtitle: String {
        switch self {
        case .beginner: return L10n.Onboarding.beginnerDescription
        case .intermediate: return L10n.Onboarding.intermediateDescription
        case .advanced: return L10n.Onboarding.advancedDescription
        }
    }
}
