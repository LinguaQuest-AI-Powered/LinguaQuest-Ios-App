//
//  BossLevelHeaderView.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import SwiftUI

struct BossLevelHeaderView: View {
    let title: String
    let status: BossLevelConnectionStatus
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            CustomBackButton(action: onClose)
            Spacer()
            statusBadge
        }
        .overlay(
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color.appTextHeading)
        )
        .padding(.horizontal, 20)
        .frame(height: 64)
    }
    
    @ViewBuilder
    private var statusBadge: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            Text(statusText)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Color.appTextSecondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.appSurfaceCard.opacity(0.8))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.appBorderCool, lineWidth: 1)
        )
    }
    
    private var statusColor: Color {
        switch status {
        case .disconnected: return .gray
        case .connecting: return Color.appBrandPrimary
        case .connected: return Color.appSemanticSuccess
        case .error: return Color.appAccentRed
        }
    }
    
    private var statusText: String {
        switch status {
        case .disconnected: return L10n.BossLevel.statusDisconnected
        case .connecting: return L10n.BossLevel.statusConnecting
        case .connected: return L10n.BossLevel.statusConnected
        case .error: return L10n.BossLevel.statusError
        }
    }
}
