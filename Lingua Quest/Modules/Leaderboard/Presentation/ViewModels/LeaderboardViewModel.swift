//
//  LeaderboardViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class LeaderboardViewModel {
     var topUsers: [LeaderboardUser] = []
     var otherUsers: [LeaderboardUser] = []
    var router : RouterProtocol?
    init(router : RouterProtocol) {
        self.router = router
        loadMockData()
    }
    
    func backToProfile(){
        router?.pop()
    }
    
    private func loadMockData() {
        topUsers = [
            LeaderboardUser(id: "1", rank: 1, name: "Al3dwy", title: "Explorer", image: "user1", xp: 4250, avatarName: "advanced", isCurrentUser: false),
            LeaderboardUser(id: "2", rank: 2, name: "Ferdinand", title: "Aviator", image: "user2", xp: 3890, avatarName: "intermediate", isCurrentUser: false),
            LeaderboardUser(id: "3", rank: 3, name: "Ferdinand", title: "Traveler", image: "user3", xp: 3420, avatarName: "beginner", isCurrentUser: false)
        ]
        
        otherUsers = [
            LeaderboardUser(id: "98", rank: 98, name: "Ferdinand M.", title: "Novice", image: "user1", xp: 2900, avatarName: "beginner", isCurrentUser: false),
            LeaderboardUser(id: "99", rank: 99, name: "Ferdinand", title: "Guide", image: "user2", xp: 2750, avatarName: "advanced", isCurrentUser: false),
            LeaderboardUser(id: "100", rank: 100, name: "Explorer Sam", title: "Adventurer", image: "user3", xp: 3150, avatarName: "intermediate", isCurrentUser: true),
            LeaderboardUser(id: "101", rank: 101, name: "Zheng He", title: "Admiral", image: "user1", xp: 2600, avatarName: "advanced", isCurrentUser: false),
            LeaderboardUser(id: "102", rank: 102, name: "Xuanzang", title: "Monk", image: "user2", xp: 2550, avatarName: "beginner", isCurrentUser: false)
        ]
    }
}
