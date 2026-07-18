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
        HStack(spacing: 6) {
            Image(systemIcon: icon)
                .foregroundColor(iconColor)
                .font(iconSize != nil ? .system(size: iconSize!) : nil)
            
            Text(value)
                .appTextStyle(.captionBold, color: .appTextSlate)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

