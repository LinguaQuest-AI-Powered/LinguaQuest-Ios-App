//
//  LinguaLearningProgressCard.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct LinguaLearningProgressCard: View {
    // MARK: - Properties
    let languageName: String
    let journeyTitle: String
    let levelName: String
    let currentXP: Int
    let targetXP: Int
    
    // MARK: - Computed Properties
    private var progressRatio: CGFloat {
        guard targetXP > 0 else { return 0 }
        return min(CGFloat(currentXP) / CGFloat(targetXP), 1.0)
    }
    
    private var percentageString: String {
        "\(Int(progressRatio * 100))%"
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            progressSection
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appProfileProgressCardBg)
                .shadow(color: .appProfileCardBorder, radius: 0, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.appProfileCardBorder, lineWidth: 2)
        )
    }
}

// MARK: - Subviews
extension LinguaLearningProgressCard {
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemIcon: .globe)
                .font(.system(size: 26))
                .foregroundColor(.appPrimaryColor)
                .frame(width: 56, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appViewBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.appProfileCardBorder, lineWidth: 1)
                )
            
            // Titles
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.Profile.learningTitle(languageName))
                    .appTextStyle(.buttonBold, color: .appTextDarkBlue)
                
                Text(journeyTitle)
                    .appTextStyle(.captionMedium, color: .appTextBrown)
            }
            
            Spacer()
            
            // Level Badge
            Text(levelName)
                .appTextStyle(.micro, color: .appProfileBadgeTealText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.appProfileBadgeTealBg)
                .cornerRadius(8)
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(L10n.Profile.xpToNextMilestone(current: currentXP, total: targetXP))
                    .appTextStyle(.captionMedium, color: .appTextBrown)
                
                Spacer()
                
                // Circular Progress
                ZStack {
                    Circle()
                        .strokeBorder(Color.appProfileCardBorder.opacity(0.4), lineWidth: 4)
                    
                    Circle()
                        .trim(from: 0, to: progressRatio)
                        .stroke(Color.appPrimaryColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .padding(2)
                    
                    Text(percentageString)
                        .appTextStyle(.micro, color: .appProfileTextBrownDark)
                }
                .frame(width: 48, height: 48)
            }
            
            // Linear Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.appViewBackground)
                        .frame(height: 12)
                        .overlay(
                            Capsule().strokeBorder(Color.appProfileCardBorder, lineWidth: 1)
                        )
                    
                    Capsule()
                        .fill(Color.appPrimaryColor)
                        .frame(width: geometry.size.width * progressRatio, height: 12)
                        .shadow(color: Color.appPrimaryColor.opacity(0.4), radius: 4, x: 0, y: 0)
                }
            }
            .frame(height: 12)
        }
    }
}

// MARK: - Preview
#Preview {
    LinguaLearningProgressCard(
        languageName: L10n.Onboarding.languageFrench,
        journeyTitle: "Intermediate Journey",
        levelName: "B1 LEVEL",
        currentXP: 2450,
        targetXP: 3000
    )
    .padding()
}
