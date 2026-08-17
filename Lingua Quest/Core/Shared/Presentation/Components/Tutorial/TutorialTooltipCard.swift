//
//  TutorialTooltipCard.swift
//  Lingua Quest
//
//  Created by siam on 13/08/2026.
//

import SwiftUI

struct TutorialTooltipCard: View {
    let step: TutorialStepType
    let currentStepIndex: Int
    let totalSteps: Int
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var title: String {
        switch step {
        case .dailyReward: return L10n.Tutorial.dailyRewardTitle
        case .learningProgress: return L10n.Tutorial.learningProgressTitle
        case .currentLesson: return L10n.Tutorial.currentLessonTitle
        case .dailyMission: return L10n.Tutorial.dailyMissionTitle
        case .coins: return L10n.Tutorial.coinsTitle
        case .xp: return L10n.Tutorial.xpTitle
        case .notifications: return L10n.Tutorial.notificationsTitle
        case .exploreWorlds: return L10n.Tutorial.exploreWorldsTitle
        case .switchLanguage: return L10n.Tutorial.switchLanguageTitle
        case .gameCaptures: return L10n.Tutorial.gameCapturesTitle
        case .myJournal: return L10n.Tutorial.myJournalTitle
        case .voicePractice: return L10n.Tutorial.voicePracticeTitle
        case .roleplay: return L10n.Tutorial.roleplayTitle
        case .mindReader: return L10n.Tutorial.mindReaderTitle
        case .yourProfile: return L10n.Tutorial.yourProfileTitle
        case .profileStats: return L10n.Tutorial.profileStatsTitle
        case .settings: return L10n.Tutorial.settingsTitle
        case .achievements: return L10n.Tutorial.achievementsTitle
        case .leaderboard: return L10n.Tutorial.leaderboardTitle
        }
    }
    
    var description: String {
        switch step {
        case .dailyReward: return L10n.Tutorial.dailyRewardDesc
        case .learningProgress: return L10n.Tutorial.learningProgressDesc
        case .currentLesson: return L10n.Tutorial.currentLessonDesc
        case .dailyMission: return L10n.Tutorial.dailyMissionDesc
        case .coins: return L10n.Tutorial.coinsDesc
        case .xp: return L10n.Tutorial.xpDesc
        case .notifications: return L10n.Tutorial.notificationsDesc
        case .exploreWorlds: return L10n.Tutorial.exploreWorldsDesc
        case .switchLanguage: return L10n.Tutorial.switchLanguageDesc
        case .gameCaptures: return L10n.Tutorial.gameCapturesDesc
        case .myJournal: return L10n.Tutorial.myJournalDesc
        case .voicePractice: return L10n.Tutorial.voicePracticeDesc
        case .roleplay: return L10n.Tutorial.roleplayDesc
        case .mindReader: return L10n.Tutorial.mindReaderDesc
        case .yourProfile: return L10n.Tutorial.yourProfileDesc
        case .profileStats: return L10n.Tutorial.profileStatsDesc
        case .settings: return L10n.Tutorial.settingsDesc
        case .achievements: return L10n.Tutorial.achievementsDesc
        case .leaderboard: return L10n.Tutorial.leaderboardDesc
        }
    }
    
    var isLastStep: Bool {
        currentStepIndex == totalSteps - 1
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                Text(title)
                    .font(AppTextStyle.headingMedium.font)
                    .foregroundColor(.appTextHeading)
                
                Spacer()
                
                Button(action: onSkip) {
                    Text(L10n.Tutorial.skip)
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(.appTextSecondary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
            }
            
            HStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.appAccentOrange)
                        .frame(width: 64, height: 64)
                    
                    Image(asset: mascotForStep(step))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .offset(y: 4)
                }
                
                Text(description)
                    .font(AppTextStyle.bodyMedium.font)
                    .foregroundColor(.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 0)
            }
            
            HStack {
                HStack(spacing: 6) {
                    ForEach(0..<totalSteps, id: \.self) { index in
                        Capsule()
                            .fill(index == currentStepIndex ? Color.appAccentOrange : Color.appTextSecondary.opacity(0.3))
                            .frame(width: index == currentStepIndex ? 16 : 6, height: 6)
                    }
                }
                
                Spacer()
                
                Button(action: onNext) {
                    Text(isLastStep ? L10n.Tutorial.done : L10n.Tutorial.next)
                        .font(AppTextStyle.bodyBold.font)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.appAccentOrange)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurfaceCard)
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 12, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.5), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    private func mascotForStep(_ step: TutorialStepType) -> Image.Asset {
        switch step {
        case .dailyReward: return .mascotReward
        case .learningProgress: return .bird
        case .currentLesson: return .myCaptureBird
        case .dailyMission: return .dailyMission
        case .coins: return .mascotReward
        case .xp: return .leaderBoardBird
        case .notifications: return .bird2
        case .exploreWorlds: return .mascotReward
        case .switchLanguage: return .bird
        case .gameCaptures: return .myCaptureBird
        case .myJournal: return .bird
        case .voicePractice: return .micBird
        case .roleplay: return .bird3
        case .mindReader: return .mindBird
        case .yourProfile: return .myCaptureBird
        case .profileStats: return .achivementBird
        case .settings: return .mascotSettings
        case .achievements: return .achivementBird
        case .leaderboard: return .leaderBoardBird
        }
    }
}
