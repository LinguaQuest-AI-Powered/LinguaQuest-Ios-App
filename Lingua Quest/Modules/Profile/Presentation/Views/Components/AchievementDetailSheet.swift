//
//  AchievementDetailSheet.swift
//  Lingua Quest
//
//  Created by taqieallah on 06/08/2026.
//

import SwiftUI

struct AchievementDetailSheet: View {
    let title: String
    let subtitle: String
    let uiIcon: Image.SystemIcon
    let uiIconColor: Color
    var iconUrl: String? = nil
    let status: AchievementStatus
    let progressPercent: Int
    let xpReward: Int
    let coinsReward: Int
    let earnedAt: String?
    var onClose: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var isEarned: Bool {
        status.isEarned
    }
    
    var statusText: String {
        switch status {
        case .earned, .unlocked:
            return L10n.Achievements.earnedLabel.uppercased()
        case .locked:
            return L10n.Achievements.filterLocked.uppercased()
        case .inProgress:
            return L10n.Achievements.inProgressLabel.uppercased()
        case .unknown:
            return isEarned ? L10n.Achievements.earnedLabel.uppercased() : L10n.Achievements.filterLocked.uppercased()
        }
    }
    
    var formattedEarnedDate: String? {
        guard let date = earnedAt, !date.isEmpty else { return nil }
        if date.contains("T") {
            let rawDateString = date.components(separatedBy: "T").first ?? date
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = inputFormatter.date(from: rawDateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateStyle = .medium
                return outputFormatter.string(from: parsedDate)
            }
            return rawDateString
        }
        return date
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header with Close X Button
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemIcon: .xmark)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.appTextSecondary)
                        .frame(width: 32, height: 32)
                        .background(Color.appSurfaceCardWarm)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 4)
            
            // Icon Badge Circle Container
            ZStack {
                Circle()
                    .fill(isEarned ? Color.appBadgeTealBg.opacity(0.5) : Color.appSurfaceCardMuted)
                    .frame(width: 80, height: 80)
                
                detailSheetIcon
                    .frame(width: 44, height: 44)
            }
            
            // Status Pill Badge
            Text(statusText)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(isEarned ? Color.appBadgeTealText : .appTextSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(isEarned ? Color.appBadgeTealBg : Color.appSurfaceCardMuted)
                .clipShape(Capsule())
            
            // Title and Description
            VStack(spacing: 4) {
                Text(title)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .appTextStyle(.body, color: .appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            
            // Progress Bar Section
            VStack(spacing: 8) {
                HStack {
                    Text(L10n.Home.progress)
                        .appTextStyle(.bodyBold, color: .appTextHeading)
                    Spacer()
                    Text("\(progressPercent)%")
                        .appTextStyle(.bodyBold, color: .appAccentTeal)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.appSurfaceCardMuted)
                            .frame(height: 12)
                        
                        Capsule()
                            .fill(Color.appAccentTeal)
                            .frame(width: max(0, min(geo.size.width * CGFloat(progressPercent) / 100.0, geo.size.width)), height: 12)
                    }
                }
                .frame(height: 12)
            }
            .padding(14)
            .background(Color.appSurfaceCardWarm.opacity(0.6))
            .cornerRadius(16)
            
            // Rewards Section (Using RewardBadge per Rule 17)
            HStack(spacing: 16) {
                RewardBadge(type: .xp, value: "+\(xpReward)", size: .normal)
                    .frame(maxWidth: .infinity)
                
                RewardBadge(type: .coin, value: "+\(coinsReward)", size: .normal)
                    .frame(maxWidth: .infinity)
            }
            
            // Earned Date (if applicable)
            if isEarned, let date = formattedEarnedDate {
                Text(L10n.Achievements.earnedOn(date))
                    .appTextStyle(.caption, color: .appTextSecondary)
            }
            
            
            Spacer(minLength: 24)
            
            // Action Button
            CustomButton(
                type: .secendry,
                text: L10n.Common.cancel,
                action: onClose
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    private var detailSheetIcon: some View {
        if let iconUrlString = iconUrl,
           !iconUrlString.isEmpty,
           (iconUrlString.hasPrefix("http://") || iconUrlString.hasPrefix("https://")),
           let url = URL(string: iconUrlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    fallbackIcon
                @unknown default:
                    fallbackIcon
                }
            }
        } else {
            fallbackIcon
        }
    }
    
    private var fallbackIcon: some View {
        Image(systemIcon: uiIcon)
            .resizable()
            .scaledToFit()
            .foregroundColor(isEarned ? uiIconColor : .appTextSecondary)
    }
}
