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
    let iconUrl: String?
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
            return "COMPLETED"
        case .locked:
            return "LOCKED"
        case .inProgress:
            return "IN PROGRESS"
        case .unknown:
            return isEarned ? "COMPLETED" : "LOCKED"
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
                
                if let urlString = iconUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                        case .failure:
                            Image(systemIcon: .starFill)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                                .foregroundColor(isEarned ? .appAccentTeal : .appTextSecondary)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemIcon: isEarned ? .starFill : .lockFill)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundColor(isEarned ? .appAccentTeal : .appTextSecondary)
                }
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
                    Text("Progress")
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
                RewardBadge(type: .xp, value: "+\(xpReward) XP", size: .normal)
                    .frame(maxWidth: .infinity)
                
                RewardBadge(type: .coin, value: "+\(coinsReward) Coins", size: .normal)
                    .frame(maxWidth: .infinity)
            }
            
            // Earned Date (if applicable)
            if isEarned, let date = formattedEarnedDate {
                Text("Earned on \(date)")
                    .appTextStyle(.caption, color: .appTextSecondary)
            }
            
            // Action Button
            CustomButton(
                type: .secendry,
                text: L10n.Common.cancel,
                action: onClose
            )
        }
        .padding(16)
        .background(Color.appBackgroundWarm)
    }
}
