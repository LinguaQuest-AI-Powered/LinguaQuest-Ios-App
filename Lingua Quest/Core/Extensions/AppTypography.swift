//
//  AppTypography.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

enum AppTextStyle {
    case largeTitle      // 34, bold
    case title           // 30, bold
    case headline        // 28, bold
    case cardTitle       // 22, semibold
    case subtitle        // 18, regular
    case subtitleMedium  // 18, medium
    case body            // 16, regular
    case buttonBold      // 16, bold
    case buttonMedium    // 16, medium
    case caption         // 14, regular
    case captionMedium   // 14, medium
    case micro           // 10, bold
    case statValue       // 18, bold
    case statLabel       // 12, heavy/800
    
    var font: Font {
        switch self {
        case .largeTitle:     return .system(size: 34, weight: .bold)
        case .title:          return .system(size: 30, weight: .bold)
        case .headline:       return .system(size: 28, weight: .bold)
        case .cardTitle:      return .system(size: 22, weight: .semibold)
        case .subtitle:       return .system(size: 18, weight: .regular)
        case .subtitleMedium: return .system(size: 18, weight: .medium)
        case .body:           return .system(size: 16, weight: .regular)
        case .buttonBold:     return .system(size: 16, weight: .bold)
        case .buttonMedium:   return .system(size: 16, weight: .medium)
        case .caption:        return .system(size: 14, weight: .regular)
        case .captionMedium:  return .system(size: 14, weight: .medium)
        case .micro:          return .system(size: 10, weight: .bold)
        case .statValue:      return .system(size: 18, weight: .bold)
        case .statLabel:      return .system(size: 12, weight: .heavy)
        }
    }
}

extension View {
    func appTextStyle(_ style: AppTextStyle, color: Color = .appBackgroundLightBlue) -> some View {
        self
            .font(style.font)
            .foregroundColor(color)
    }
}

