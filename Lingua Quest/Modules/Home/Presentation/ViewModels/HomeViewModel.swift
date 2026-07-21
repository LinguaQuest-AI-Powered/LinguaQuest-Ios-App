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
    private let getHomeWorldsUseCase: GetHomeWorldsUseCaseProtocol
    private let router: RouterProtocol
    
    var homeData: HomeData?
    var fetchedWorlds: [ExploreWorld] = []
    var isLoading = false
    var errorMessage: String?
    
    var displayWorlds: [WorldUIModel] {
        return fetchedWorlds.map(WorldUIMapper.map)
    }
    
    let dailyRewardViewModel: DailyRewardViewModel
    
    init(
        getHomeDataUseCase: GetHomeDataUseCaseProtocol,
        getHomeWorldsUseCase: GetHomeWorldsUseCaseProtocol,
        dailyRewardViewModel: DailyRewardViewModel,
        router: RouterProtocol
    ) {
        self.getHomeDataUseCase = getHomeDataUseCase
        self.getHomeWorldsUseCase = getHomeWorldsUseCase
        self.dailyRewardViewModel = dailyRewardViewModel
        self.router = router
    }
    
    func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        async let homeDataTask = getHomeDataUseCase.execute()
        async let worldsTask = getHomeWorldsUseCase.execute(languageId: 1, difficulty: "EASY")
        
        do {
            homeData = try await homeDataTask
        } catch {
            print("Failed to fetch home data: \(error)")
            errorMessage = error.localizedDescription
        }
        
        do {
            fetchedWorlds = try await worldsTask
        } catch {
            print("Failed to fetch worlds: \(error)")
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
