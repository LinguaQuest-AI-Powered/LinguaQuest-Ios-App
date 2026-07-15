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
    let name: String
    let flag: ImageResource
}

enum UserLevel: String, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    //TODO: change hard coded texts 
    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }

    var subtitle: String {
        switch self {
        case .beginner: return "I'm just starting my adventure"
        case .intermediate: return "I can navigate basic paths"
        case .advanced: return "Ready for grand challenges"
        }
    }
}
