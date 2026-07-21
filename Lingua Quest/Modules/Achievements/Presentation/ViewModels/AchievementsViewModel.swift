//
//  AchievementsViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import SwiftUI
import Observation

@Observable @MainActor
final class AchievementsViewModel {
    
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let getAchievementsUseCase: GetAchievementsUseCaseProtocol
    private let getWeeklyRewardUseCase: GetWeeklyRewardUseCaseProtocol
    private let claimWeeklyRewardUseCase: ClaimWeeklyRewardUseCaseProtocol
    
    // MARK: - State
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var earnedCount: Int = 0
    var inProgressCount: Int = 0
    var xpEarned: Int = 0
    var achievements: [FullAchievementUIModel] = []
    
    // MARK: - Weekly Reward State
    var weeklyReward: WeeklyRewardEntity? = nil
    var isClaimingReward: Bool = false
    
    var showClaimAlert: Bool = false
    var claimAlertMessage: String = ""
    
    init(
        router: RouterProtocol,
        getAchievementsUseCase: GetAchievementsUseCaseProtocol,
        getWeeklyRewardUseCase: GetWeeklyRewardUseCaseProtocol,
        claimWeeklyRewardUseCase: ClaimWeeklyRewardUseCaseProtocol
    ) {
        self.router = router
        self.getAchievementsUseCase = getAchievementsUseCase
        self.getWeeklyRewardUseCase = getWeeklyRewardUseCase
        self.claimWeeklyRewardUseCase = claimWeeklyRewardUseCase
    }
    
    // MARK: - Actions
    
    func onBackTapped() {
        router.pop()
    }
    
    func loadAchievements(status: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let achievementsTask = getAchievementsUseCase.execute(status: status)
            async let weeklyRewardTask = getWeeklyRewardUseCase.execute()
            
            let data = try await achievementsTask
            let rewardData = try? await weeklyRewardTask
            
            self.weeklyReward = rewardData
            
            self.earnedCount = data.earnedCount
            self.inProgressCount = data.inProgressCount
            self.xpEarned = data.xpEarned
            self.achievements = data.achievements.map { entity in
                FullAchievementUIModel(
                    id: entity.id,
                    title: entity.title,
                    subtitle: entity.subtitle,
                    iconUrl: entity.iconUrl,
                    status: entity.status,
                    progressPercent: entity.progressPercent
                )
            }
        } catch {
            self.errorMessage = L10n.Network.unknown
            print("Failed to fetch achievements: \(error)")
        }
        
        isLoading = false
    }
    
    func claimWeeklyReward() async {
        guard let reward = weeklyReward, !reward.claimedThisWeek else { return }
        
        isClaimingReward = true
        do {
            let result = try await claimWeeklyRewardUseCase.execute()
            
            // Update local state to reflect claimed
            self.weeklyReward = WeeklyRewardEntity(
                claimedThisWeek: true,
                rewardXp: reward.rewardXp,
                rewardCoins: reward.rewardCoins
            )
            
            self.claimAlertMessage = "You claimed \(result.xpAwarded) XP and \(result.coinsAwarded) Coins!\nNew Balances:\nXP: \(result.newXpBalance)\nCoins: \(result.newCoinsBalance)"
            self.showClaimAlert = true
            
        } catch {
            self.errorMessage = L10n.Network.unknown
            print("Failed to claim reward: \(error)")
        }
        isClaimingReward = false
    }
}
