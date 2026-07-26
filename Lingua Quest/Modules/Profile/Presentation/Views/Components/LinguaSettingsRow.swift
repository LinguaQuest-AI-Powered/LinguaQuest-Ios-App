//
//  LinguaSettingsRow.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Highly reusable row for Settings items
struct LinguaSettingsRow<TrailingView: View>: View {
    // MARK: - Properties
    let icon: Image.SystemIcon
    let iconBgColor: Color
    let title: String
    let showDivider: Bool
    @ViewBuilder let trailingView: TrailingView
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                iconBadge
                
                Text(title)
                    .appTextStyle(.bodyLargeMedium, color: .appTextHeading)
                
                Spacer()
                
                trailingView
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            if showDivider {
                Divider()
                    .background(Color.appBorderBrown.opacity(0.5))
                    .padding(.leading, 64)
            }
        }
        .contentShape(Rectangle())
    }
    
    // MARK: - Subviews
    private var iconBadge: some View {
        ZStack {
            Circle()
                .fill(iconBgColor.opacity(0.15))
                .frame(width: 32, height: 32)
            
            Image(systemIcon: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(iconBgColor)
        }
    }
}

/// Shared trailing chevron used by navigational rows
struct SettingsRowChevron: View {
    var body: some View {
        Image(systemIcon: .rightChevron)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.appBorderBrown)
            .flipsForRightToLeftLayoutDirection(true)
    }
}

/// Shared trailing "value + chevron" used by rows that show a current selection
struct SettingsRowValue: View {
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(value)
                .appTextStyle(.bodyBold, color: .appTextPrimary)
            SettingsRowChevron()
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 0) {
        LinguaSettingsRow(
            icon: .personFill,
            iconBgColor: .appAccentOrange,
            title: "Edit Profile",
            showDivider: true
        ) {
            SettingsRowChevron()
        }
        
        LinguaSettingsRow(
            icon: .globe,
            iconBgColor: .appAccentOrange,
            title: "Learning Language",
            showDivider: false
        ) {
            SettingsRowValue(value: "Spanish")
        }
    }
    .background(Color.appSurfaceCard)
    .cornerRadius(20)
    .padding()
    .background(Color.appBackgroundWarm)
}
