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
    private let getContinueLevelUseCase: GetContinueLevelUseCaseProtocol
    private let startLevelUseCase: StartLevelUseCase
    private let router: RouterProtocol
    let statsService: StatsService
    
    var homeData: HomeData?
    var fetchedWorlds: [ExploreWorld] = []
    var continueLevel: ContinueLevelEntity?
    var isLoading = false
    var isContinueLevelLoading = false
    var showErrorAlert = false
    var errorMessage: String?
    
    private var logoutToken: NotificationToken?
    private var progressToken: NotificationToken?
    
    var displayWorlds: [WorldUIModel] {
        let worldsToDisplay = fetchedWorlds.isEmpty ? (homeData?.activeLanguage.exploreWorlds ?? []) : fetchedWorlds
        return worldsToDisplay.map(WorldUIMapper.map)
    }
    
    let dailyRewardViewModel: DailyRewardViewModel
    let languageViewModel: LanguageViewModel
    
    init(
        getHomeDataUseCase: GetHomeDataUseCaseProtocol,
        getHomeWorldsUseCase: GetHomeWorldsUseCaseProtocol,
        getContinueLevelUseCase: GetContinueLevelUseCaseProtocol,
        startLevelUseCase: StartLevelUseCase,
        dailyRewardViewModel: DailyRewardViewModel,
        languageViewModel: LanguageViewModel,
        statsService: StatsService,
        router: RouterProtocol
    ) {
        self.getHomeDataUseCase = getHomeDataUseCase
        self.getHomeWorldsUseCase = getHomeWorldsUseCase
        self.getContinueLevelUseCase = getContinueLevelUseCase
        self.startLevelUseCase = startLevelUseCase
        self.dailyRewardViewModel = dailyRewardViewModel
        self.languageViewModel = languageViewModel
        self.statsService = statsService
        self.router = router
        
        // Listen for language switches to refresh home data
        self.languageViewModel.onLanguageSwitched = { [weak self] in
            Task {
                await self?.loadHomeData(forceRefresh: true)
            }
        }
        
        let token = NotificationCenter.default.addObserver(
            forName: .userDidLogout,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleLogout()
        }
        logoutToken = NotificationToken(token: token)
        
        let pToken = NotificationCenter.default.addObserver(
            forName: .progressDidUpdate,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task {
                await self?.loadHomeData(forceRefresh: true)
            }
        }
        progressToken = NotificationToken(token: pToken)
    }
    
    private func handleLogout() {
        hasLoadedInitialData = false
        homeData = nil
        fetchedWorlds = []
        continueLevel = nil
        errorMessage = nil
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
        async let statsTask = statsService.fetchStats()
        async let continueLevelTask: ContinueLevelEntity? = try? getContinueLevelUseCase.execute()
        
        do {
            let data = try await homeDataTask
            homeData = data
            statsService.syncBalances(coins: data.coins, xp: data.xp, streakDays: data.streakDays)
        } catch {
            print("Failed to fetch home data: \(error)")
            errorMessage = error.localizedDescription
        }
        
        do {
            fetchedWorlds = try await worldsTask
        } catch {
            print("Failed to fetch worlds: \(error)")
        }
        
        do {
            try await statsTask
        } catch {
            print("Failed to fetch stats on home: \(error)")
        }
        
        continueLevel = await continueLevelTask
        
        isLoading = false
    }
    
    func navigateToAllWorlds() {
        router.push(.allWorlds)
    }
    
    func navigateToGameLevels(worldId: Int, worldName: String, languageId: Int) {
        router.push(.gameLevels(worldId: worldId, worldName: worldName, languageId: languageId))
    }
    
    func onObjectDetectionTapped() async {
        guard !isContinueLevelLoading else { return }
        isContinueLevelLoading = true
        defer { isContinueLevelLoading = false }
        
        do {
            guard let continueLevel = try await getContinueLevelUseCase.execute() else {
                self.errorMessage = L10n.Game.noAvailableLevels
                self.showErrorAlert = true
                return
            }
            
            let targetWord: String
            if let word = continueLevel.word, !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                targetWord = word
            } else {
                let startEntity = try await startLevelUseCase.execute(worldId: continueLevel.worldId, levelId: continueLevel.levelId)
                targetWord = startEntity.targetWord
            }
            
            router.push(.cameraQuestTask(
                worldId: continueLevel.worldId,
                worldName: continueLevel.worldName,
                levelId: continueLevel.levelId,
                levelOrder: continueLevel.levelOrder,
                targetWord: targetWord
            ))
        } catch let error as NetworkError {
            if let message = error.apiErrorMessage {
                self.errorMessage = message
            } else {
                self.errorMessage = error.localizedDescription
            }
            self.showErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true
        }
    }
}
