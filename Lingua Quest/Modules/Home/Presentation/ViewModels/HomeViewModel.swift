//
//  HomeViewModel.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private let getHomeDataUseCase: GetHomeDataUseCaseProtocol
    private let router: RouterProtocol

    var homeData: HomeData?
    var isLoading = false
    var errorMessage: String?
    
    var displayWorlds: [WorldUIModel] {
        guard let worlds = homeData?.activeLanguage.exploreWorlds else { return [] }
        return worlds.map { exploreWorld in
            let difficulty: WorldDifficulty = {
                switch exploreWorld.difficulty {
                case "EASY": return .easy
                case "MEDIUM": return .medium
                default: return .hard
                }
            }()
            
            let assetName = URL(fileURLWithPath: exploreWorld.imageUrl).deletingPathExtension().lastPathComponent
            
            return WorldUIModel(
                id: "\(exploreWorld.id)",
                title: exploreWorld.name,
                uiImage: Image.Asset(rawValue: assetName) ?? .city,
                difficulty: difficulty,
                uiDifficultyLabel: WorldUIMapper.label(for: difficulty),
                uiBadgeColor: WorldUIMapper.badgeColor(for: difficulty),
                progress: Double(exploreWorld.progressPercent) / 100.0,
                isCompleted: exploreWorld.status == "COMPLETED",
                isLocked: exploreWorld.status == "LOCKED",
                unlockLevel: nil
            )
        }
    }

    init(getHomeDataUseCase: GetHomeDataUseCaseProtocol, router: RouterProtocol) {
        self.getHomeDataUseCase = getHomeDataUseCase
        self.router = router
    }

    func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        do {
            homeData = try await getHomeDataUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func navigateToAllWorlds() {
        router.push(.allWorlds)
    }

    func navigateToGameLevels(worldName: String) {
        router.push(.gameLevels(worldName: worldName))
    }
}
