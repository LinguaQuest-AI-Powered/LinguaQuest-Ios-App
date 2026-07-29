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
    // MARK: - Displayed Data
    var topUsers: [LeaderboardUser] = []
    var otherUsers: [LeaderboardUser] = []

    // MARK: - State
    var isLoading: Bool = false
    var isLoadingNextPage: Bool = false
    var isLoadingPreviousPage: Bool = false
    var errorMessage: String? = nil

    // MARK: - Bidirectional Pagination State (0-indexed)
    private(set) var minLoadedPage: Int = 0
    private(set) var maxLoadedPage: Int = 0
    private(set) var hasMoreTop: Bool = false
    private(set) var hasMoreBottom: Bool = true
    private(set) var myRank: Int = 0
    private(set) var canTriggerPagination: Bool = false
    /// The ID we should scroll to after initial load
    private(set) var scrollToUserId: String? = nil
    let pageLimit: Int = 10

    private let router: RouterProtocol
    private let getLeaderboardUseCase: GetLeaderboardUseCaseProtocol
    let languageId: Int

    init(router: RouterProtocol, getLeaderboardUseCase: GetLeaderboardUseCaseProtocol, languageId: Int) {
        self.router = router
        self.getLeaderboardUseCase = getLeaderboardUseCase
        self.languageId = languageId
    }

    // MARK: - Navigation
    func backToProfile() {
        router.pop()
    }

    // MARK: - Initial Load
    func fetchLeaderboard() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        hasMoreTop = false
        hasMoreBottom = true
        scrollToUserId = nil
        canTriggerPagination = false
        minLoadedPage = 0
        maxLoadedPage = 0

        Task {
            do {
                
                let pageZeroData = try await getLeaderboardUseCase.execute(
                    scope: "GLOBAL",
                    languageId: languageId,
                    page: 0,
                    limit: pageLimit
                )

                topUsers = pageZeroData.topThree.map { mapToUIModel($0) }
                myRank = pageZeroData.myRank

                let filteredEntries = pageZeroData.entries.filter { $0.rank > 3 }
                otherUsers = filteredEntries.map { mapToUIModel($0) }

                minLoadedPage = 0
                maxLoadedPage = 0
                hasMoreTop = false
                hasMoreBottom = pageZeroData.hasMore
                isLoading = false

                Task {
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    canTriggerPagination = true
                }
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }

    // MARK: - Load Previous Page (scroll up)
    func loadPreviousPageIfNeeded(currentItem: LeaderboardUser) {
        guard canTriggerPagination,
              hasMoreTop,
              !isLoadingPreviousPage,
              !isLoading,
              minLoadedPage > 0
        else { return }

        let topSlice = otherUsers.prefix(5)
        guard topSlice.contains(where: { $0.id == currentItem.id }) else { return }

        isLoadingPreviousPage = true

        Task {
            do {
                let prevPage = minLoadedPage - 1
                let data = try await getLeaderboardUseCase.execute(
                    scope: "GLOBAL",
                    languageId: languageId,
                    page: prevPage,
                    limit: pageLimit
                )
                let existingIds = Set(otherUsers.map { $0.id })
                let newUsers = data.entries
                    .filter { $0.rank > 3 }
                    .map { mapToUIModel($0) }
                    .filter { !existingIds.contains($0.id) }

                otherUsers.insert(contentsOf: newUsers, at: 0)
                minLoadedPage = prevPage
                hasMoreTop = (minLoadedPage > 0)
                isLoadingPreviousPage = false
            } catch {
                isLoadingPreviousPage = false
            }
        }
    }

    // MARK: - Load Next Page (scroll down)
    func loadNextPageIfNeeded(currentItem: LeaderboardUser) {
        guard canTriggerPagination,
              hasMoreBottom,
              !isLoadingNextPage,
              !isLoading
        else { return }

        let bottomSlice = otherUsers.suffix(5)
        guard bottomSlice.contains(where: { $0.id == currentItem.id }) else { return }

        isLoadingNextPage = true

        Task {
            do {
                let nextPage = maxLoadedPage + 1
                let data = try await getLeaderboardUseCase.execute(
                    scope: "GLOBAL",
                    languageId: languageId,
                    page: nextPage,
                    limit: pageLimit
                )
                let existingIds = Set(otherUsers.map { $0.id })
                let newUsers = data.entries
                    .filter { $0.rank > 3 }
                    .map { mapToUIModel($0) }
                    .filter { !existingIds.contains($0.id) }

                otherUsers.append(contentsOf: newUsers)
                maxLoadedPage = nextPage
                hasMoreBottom = data.hasMore
                isLoadingNextPage = false
            } catch {
                isLoadingNextPage = false
            }
        }
    }

    // MARK: - Mapping
    private func mapToUIModel(_ entity: LeaderboardUserEntity) -> LeaderboardUser {
        var fullAvatarUrl: String? = nil
        if let path = entity.avatarImage {
            if path.hasPrefix("http://") || path.hasPrefix("https://") {
                fullAvatarUrl = path
            } else {
                fullAvatarUrl = AppConfig.baseURL
                    .appendingPathComponent(path.hasPrefix("/") ? String(path.dropFirst()) : path)
                    .absoluteString
            }
        }

        return LeaderboardUser(
            id: entity.id,
            rank: entity.rank,
            name: entity.name,
            title: entity.title,
            image: fullAvatarUrl ?? "",
            xp: entity.xp,
            avatarName: "beginner",
            isCurrentUser: entity.isCurrentUser
        )
    }
}
