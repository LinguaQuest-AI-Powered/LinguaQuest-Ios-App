//
//  DailyRewardDayNodeView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Renders a single day node on the reward timeline — appearance switches
/// based on whether the day is completed, the active day, or still locked
struct DailyRewardDayNodeView: View {
    // MARK: - Properties
    let status: DailyRewardDayStatus
    
    @State private var isPulsing = false
    
    // MARK: - Body
    var body: some View {
        switch status {
        case .completed:
            badge(icon: .checkmark, iconColor: .appBorderBrown)
        case .current:
            currentNode
        case .locked:
            badge(icon: .dollarsignCircleFill, iconColor: .appBorderBrown)
        }
    }
    
    // MARK: - Subviews
    private func badge(icon: Image.SystemIcon, iconColor: Color) -> some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 32, height: 32)
            Circle().fill(Color.appSurfaceCardWarm).frame(width: 28, height: 28)
            
            Image(systemIcon: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(iconColor)
        }
    }
    
    private var currentNode: some View {
        ZStack {
            Circle()
                .fill(Color.appBrandPrimary.opacity(isPulsing ? 0 : 0.6))
                .frame(width: 48, height: 48)
                .scaleEffect(isPulsing ? 1.3 : 0.8)
            
            Circle().fill(Color.white).frame(width: 36, height: 36)
            Circle().fill(Color.appBrandPrimary).frame(width: 28, height: 28)
            
            Image(systemIcon: .dollarsignCircleFill)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 24) {
        DailyRewardDayNodeView(status: .completed)
        DailyRewardDayNodeView(status: .current)
        DailyRewardDayNodeView(status: .locked)
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
