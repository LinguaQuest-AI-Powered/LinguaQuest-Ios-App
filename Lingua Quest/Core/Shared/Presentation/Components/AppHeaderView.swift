//
//  AppHeaderView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 17/07/2026.
//

import SwiftUI

struct AppHeaderView: View {
    var starCount: Int
    var coinCount: Int
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Image(.bird)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(4)
                .background(Circle().fill(Color.appSurfaceCard))
                .overlay(Circle().stroke(Color.appBorderBrown, lineWidth: 2))
                .shadow(color: .black.opacity(0.1), radius: 3)
            
            Text("LinguaQuest")
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundColor(.appBrandBrown)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            
            Spacer()
            
            RewardBadge(type: .xp, value: formatValue(starCount), size: .normal)
            RewardBadge(type: .coin, value: formatValue(coinCount), size: .normal)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
        )
    }
    
    private func formatValue(_ value: Int) -> String {
        if value >= 1_000_000 {
            let formatted = String(format: "%.1fM", Double(value) / 1_000_000)
            return formatted.replacingOccurrences(of: ".0M", with: "M")
        } else if value >= 10_000 {
            let formatted = String(format: "%.1fK", Double(value) / 1_000)
            return formatted.replacingOccurrences(of: ".0K", with: "K")
        } else {
            return "\(value)"
        }
    }
}
