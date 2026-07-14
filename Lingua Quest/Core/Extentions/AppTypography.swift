//
//  AppTypography.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

enum AppTextStyle {
    case largeTitle
    case title
    case headline
    case body
    case subheadline
    case caption
    case button
    
  var font: Font {
        switch self {
        case .largeTitle: return .system(size: 34, weight: .bold)
        case .title:      return .system(size: 24, weight: .bold)
        case .headline:   return .system(size: 18, weight: .semibold)
        case .body:       return .system(size: 16, weight: .regular)
        case .subheadline: return .system(size: 14, weight: .regular)
        case .caption:    return .system(size: 12, weight: .regular)
        case .button:     return .system(size: 16, weight: .semibold)
        }
    }
}
extension View {
    func appTextStyle(_ style: AppTextStyle, color: Color = .appTextPrimary) -> some View {
        self
            .font(style.font)
            .foregroundColor(color)
    }
}
