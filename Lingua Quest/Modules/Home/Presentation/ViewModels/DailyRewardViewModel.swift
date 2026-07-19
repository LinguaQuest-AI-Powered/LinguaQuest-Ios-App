//
//  DailyRewardViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Observation

@Observable
final class DailyRewardViewModel {
    // MARK: - Constants
    private let visibleNodesCount = 5
    
    // MARK: - State
    var reward: DailyRewardEntity
    var isClaimed: Bool = false
    
    // MARK: - Init
    init(reward: DailyRewardEntity = DailyRewardEntity(currentDay: 3, rewardAmount: 50)) {
        self.reward = reward
    }
    
    // MARK: - UI Model
    /// A sliding 5-day window centered around the current day —
    var timelineDays: [DailyRewardDayUIModel] {
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
    func claimReward() {
        isClaimed = true
        // Persisting the claim (API call / local storage) will be added
        // once the rewards backend is wired in
    }
}
