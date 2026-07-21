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
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let router: RouterProtocol
    private let getLeaderboardUseCase: GetLeaderboardUseCaseProtocol
    private let languageId: Int
    
    init(router: RouterProtocol, getLeaderboardUseCase: GetLeaderboardUseCaseProtocol, languageId: Int) {
        self.router = router
        self.getLeaderboardUseCase = getLeaderboardUseCase
        self.languageId = languageId
    }
    
    func backToProfile() {
        router.pop()
    }
    
    func fetchLeaderboard(scope: String = "GLOBAL", page: Int = 1, limit: Int = 20) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let data = try await getLeaderboardUseCase.execute(
                    scope: scope,
                    languageId: languageId,
                    page: page,
                    limit: limit
                )
                
                await MainActor.run {
                    self.topUsers = data.topThree.map { self.mapToUIModel($0) }
                    self.otherUsers = data.entries.map { self.mapToUIModel($0) }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func mapToUIModel(_ entity: LeaderboardUserEntity) -> LeaderboardUser {
        var fullAvatarUrl: String? = nil
        if let path = entity.avatarImage {
            fullAvatarUrl = AppConfig.baseURL.appendingPathComponent(path.hasPrefix("/") ? String(path.dropFirst()) : path).absoluteString
        }
        
        return LeaderboardUser(
            id: entity.id,
            rank: entity.rank,
            name: entity.name,
            title: entity.title,
            image: fullAvatarUrl ?? "",
            xp: entity.xp,
            avatarName: "beginner", // fallback or derive if needed
            isCurrentUser: entity.isCurrentUser
        )
    }
}
