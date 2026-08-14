//
//  DailyRewardViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Observation
import Foundation

@Observable
final class DailyRewardViewModel {
    // MARK: - Constants
    private let visibleNodesCount = 5
    
    // MARK: - State
    var reward: DailyRewardEntity?
    var isClaimed: Bool = false
    var isLoading: Bool = false
    var isClaiming: Bool = false
    var errorMessage: String?
    
    private var logoutToken: NotificationToken?
    
    // MARK: - UseCases
    private let getDailyRewardUseCase: GetDailyRewardUseCase
    private let claimDailyRewardUseCase: ClaimDailyRewardUseCase
    private let statsService: StatsService
    private let soundPlayer: AppSoundPlayer
    
    // MARK: - Init
    init(getDailyRewardUseCase: GetDailyRewardUseCase, claimDailyRewardUseCase: ClaimDailyRewardUseCase, statsService: StatsService, soundPlayer: AppSoundPlayer) {
        self.getDailyRewardUseCase = getDailyRewardUseCase
        self.claimDailyRewardUseCase = claimDailyRewardUseCase
        self.statsService = statsService
        self.soundPlayer = soundPlayer
        
        let token = NotificationCenter.default.addObserver(
            forName: .userDidLogout,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleLogout()
        }
        logoutToken = NotificationToken(token: token)
    }
    
    private func handleLogout() {
        reward = nil
        isClaimed = false
        errorMessage = nil
    }
    
    // MARK: - UI Model
    /// A sliding 5-day window centered around the current day —
    var timelineDays: [DailyRewardDayUIModel] {
        guard let reward = reward else { return [] }
        let startDay = max(1, reward.currentDay - 2)
        let days = startDay..<(startDay + visibleNodesCount)
        
        return days.map { day in
            let status: DailyRewardDayStatus
            if day < reward.currentDay {
                status = .completed
            } else if day == reward.currentDay {
                status = .current
            } else {
                status = .locked
            }
            return DailyRewardDayUIModel(day: day, status: status)
        }
    }
    
    var completedNodesCount: Int {
        timelineDays.filter { $0.status == .completed }.count
    }
    
    // MARK: - Intentions
    
    @MainActor
    func loadDailyReward(forceRefresh: Bool = false) async {
        if reward == nil || forceRefresh {
            isLoading = true
        }
        errorMessage = nil
        do {
            reward = try await getDailyRewardUseCase.execute()
            isClaimed = reward?.claimedToday ?? false
        } catch {
            print("Failed to fetch daily reward: \(error)")
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func claimReward() async {
        isClaiming = true
        errorMessage = nil
        do {
            let claimResult = try await claimDailyRewardUseCase.execute()
            isClaimed = true
            soundPlayer.play(sound: .coin)
            // Update reward entity with new values from claim result if needed,
            // or we could just rely on the API returning claimedToday = true
            if let currentReward = reward {
                reward = DailyRewardEntity(
                    claimedToday: true,
                    currentDay: currentReward.currentDay,
                    cycleLength: currentReward.cycleLength,
                    rewardCoins: claimResult.coinsAwarded,
                    rewardXp: claimResult.xpAwarded,
                    streakDays: claimResult.newStreakDays
                )
            }
            statsService.syncBalances(
                coins: claimResult.newCoinsBalance,
                xp: claimResult.newXpBalance,
                streakDays: claimResult.newStreakDays
            )
        } catch {
            print("Failed to claim daily reward: \(error)")
            errorMessage = error.localizedDescription
        }
        isClaiming = false
    }
}
