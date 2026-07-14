//
//  AppTypography.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

enum AppTextStyle {
    case largeTitle
    case body
    case buttonBold
    
  var font: Font {
        switch self {
        case .largeTitle: return .system(size: 34, weight: .bold)
        case .body:       return .system(size: 16, weight: .regular)
        case .buttonBold: return .system(size: 16, weight: .bold)
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
