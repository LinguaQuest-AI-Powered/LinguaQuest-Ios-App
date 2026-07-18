//
//  AppTypography.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

enum AppTextStyle {
    // MARK: - Canonical Typography Tokens
    case displayLarge      // 34, bold
    case displayMedium     // 30, bold
    case displaySmall      // 28, bold
    case headingLarge      // 24, bold
    case headingMedium     // 22, semibold
    case headingMediumBold // 22, bold
    case bodyLargeBold     // 18, bold
    case bodyLargeMedium   // 18, medium
    case bodyLarge         // 18, regular
    case bodyBold          // 16, bold
    case bodySemibold      // 16, semibold
    case bodyMedium        // 16, medium
    case body              // 16, regular
    case captionBold       // 14, bold
    case captionMedium     // 14, medium
    case caption           // 14, regular
    case microHeavy        // 12, heavy
    case microBold         // 12, bold
    case microSemibold     // 12, semibold
    case micro             // 10, bold

    var font: Font {
        switch self {
        case .displayLarge:      return .system(size: 34, weight: .bold)
        case .displayMedium:     return .system(size: 30, weight: .bold)
        case .displaySmall:      return .system(size: 28, weight: .bold)
        case .headingLarge:      return .system(size: 24, weight: .bold)
        case .headingMedium:     return .system(size: 22, weight: .semibold)
        case .headingMediumBold: return .system(size: 22, weight: .bold)
        case .bodyLargeBold:     return .system(size: 18, weight: .bold)
        case .bodyLargeMedium:   return .system(size: 18, weight: .medium)
        case .bodyLarge:         return .system(size: 18, weight: .regular)
        case .bodyBold:          return .system(size: 16, weight: .bold)
        case .bodySemibold:      return .system(size: 16, weight: .semibold)
        case .bodyMedium:        return .system(size: 16, weight: .medium)
        case .body:              return .system(size: 16, weight: .regular)
        case .captionBold:       return .system(size: 14, weight: .bold)
        case .captionMedium:     return .system(size: 14, weight: .medium)
        case .caption:           return .system(size: 14, weight: .regular)
        case .microHeavy:        return .system(size: 12, weight: .heavy)
        case .microBold:         return .system(size: 12, weight: .bold)
        case .microSemibold:     return .system(size: 12, weight: .semibold)
        case .micro:             return .system(size: 10, weight: .bold)
        }
    }
    
    // MARK: - Deprecated Tokens (Do not use in new code)
    
    @available(*, deprecated, renamed: "displayLarge")
    static let largeTitle = AppTextStyle.displayLarge        // 34, bold
    
    @available(*, deprecated, renamed: "displayMedium")
    static let title = AppTextStyle.displayMedium            // 30, bold
    
    @available(*, deprecated, renamed: "displaySmall")
    static let headline = AppTextStyle.displaySmall          // 28, bold
    
    @available(*, deprecated, renamed: "headingMedium")
    static let cardTitle = AppTextStyle.headingMedium        // 22, semibold
    
    @available(*, deprecated, renamed: "bodyLarge")
    static let subtitle = AppTextStyle.bodyLarge             // 18, regular
    
    @available(*, deprecated, renamed: "bodyLargeMedium")
    static let subtitleMedium = AppTextStyle.bodyLargeMedium // 18, medium
    
    @available(*, deprecated, renamed: "bodyBold")
    static let buttonBold = AppTextStyle.bodyBold            // 16, bold
    
    @available(*, deprecated, renamed: "bodyMedium")
    static let buttonMedium = AppTextStyle.bodyMedium        // 16, medium
    
}

extension View {
    func appTextStyle(_ style: AppTextStyle, color: Color = .appTextPrimary) -> some View {
        self
            .font(style.font)
            .foregroundColor(color)
    }
}
