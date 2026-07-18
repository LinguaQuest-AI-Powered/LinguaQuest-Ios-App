//
//  LinguaBadgeView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct BadgeView: View {
    let icon: Image.SystemIcon
    let iconColor: Color
    let value: String
    var iconSize: CGFloat? = nil
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemIcon: icon)
                .foregroundColor(iconColor)
                .font(iconSize != nil ? .system(size: iconSize!) : nil)
            
            Text(value)
                .appTextStyle(.captionBold, color: .appTextSecondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.appSurfaceCard)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}
