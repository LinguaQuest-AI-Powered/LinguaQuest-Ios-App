//
//  LevelCard.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LevelCard: View {
    let level: UserLevel
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.activeLevel.opacity(0.22) : (colorScheme == .dark ? Color.white.opacity(0.12) : Color.appSecondary.opacity(0.35)))
                        .frame(width: 64, height: 64)
                    
                    Image(iconName)
                        .renderingMode(.template)
                        .foregroundColor(isSelected ? Color.activeLevel : (colorScheme == .dark ? .appTextBrown : .appIconBrown))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.title)
                        .appTextStyle(.cardTitle, color: .appTextDarkBlue)
                    
                    Text(level.subtitle)
                        .appTextStyle(.caption, color: .secondaryButtonText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.appCardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected ? Color.appPrimary : (colorScheme == .dark ? Color.white.opacity(0.25) : Color.appSecondary.opacity(0.45)),
                        lineWidth: isSelected ? 2.5 : 1
                    )
            )
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var iconName: ImageResource {
        switch level {
        case .beginner: return .beginner
        case .intermediate: return .intermediate
        case .advanced: return .advanced
        }
    }
}
