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
    let languageViewModel: LanguageViewModel
    
    init(
        getHomeDataUseCase: GetHomeDataUseCaseProtocol,
        getHomeWorldsUseCase: GetHomeWorldsUseCaseProtocol,
        dailyRewardViewModel: DailyRewardViewModel,
        languageViewModel: LanguageViewModel,
        router: RouterProtocol
    ) {
        self.getHomeDataUseCase = getHomeDataUseCase
        self.getHomeWorldsUseCase = getHomeWorldsUseCase
        self.dailyRewardViewModel = dailyRewardViewModel
        self.languageViewModel = languageViewModel
        self.router = router
        
        // Listen for language switches to refresh home data
        self.languageViewModel.onLanguageSwitched = { [weak self] in
            Task {
                await self?.loadHomeData(forceRefresh: true)
            }
        }
    }
    
    private var hasLoadedInitialData = false

    func loadHomeData(forceRefresh: Bool = false) async {
        if (!hasLoadedInitialData && homeData == nil) || forceRefresh {
            isLoading = true
        }
        
        hasLoadedInitialData = true
        errorMessage = nil
        
        if languageViewModel.myLanguages.isEmpty || forceRefresh {
            await languageViewModel.loadMyLanguages(forceRefresh: forceRefresh)
        }
        
        let currentLangId = languageViewModel.activeLanguage?.id ?? 1
        
        async let homeDataTask = getHomeDataUseCase.execute()
        async let worldsTask = getHomeWorldsUseCase.execute(languageId: currentLangId, difficulty: "EASY")
        
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
    
    func navigateToGameLevels(worldId: Int, worldName: String, languageId: Int) {
        router.push(.gameLevels(worldId: worldId, worldName: worldName, languageId: languageId))
    }
}
