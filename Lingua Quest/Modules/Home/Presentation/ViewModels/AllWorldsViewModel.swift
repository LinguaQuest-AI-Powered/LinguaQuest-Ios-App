//
//  AllWorldsViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import Observation

@Observable
@MainActor
final class AllWorldsViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let getHomeWorldsUseCase: GetHomeWorldsUseCaseProtocol
    private let languageViewModel: LanguageViewModel
    
    // MARK: - State
    var isLoading: Bool = false
    var selectedFilter: WorldDifficulty? = nil
    private var worlds: [ExploreWorld] = []
    
    // MARK: - Init
    init(router: RouterProtocol, getHomeWorldsUseCase: GetHomeWorldsUseCaseProtocol, languageViewModel: LanguageViewModel) {
        self.router = router
        self.getHomeWorldsUseCase = getHomeWorldsUseCase
        self.languageViewModel = languageViewModel
        Task { await loadWorlds() }
    }
    
    // MARK: - UI Model
    var displayWorlds: [WorldUIModel] {
        let filtered = selectedFilter.map { filter in
            let filterString: String = {
                switch filter {
                case .easy: return "EASY"
                case .medium: return "MEDIUM"
                case .hard: return "HARD"
                }
            }()
            return worlds.filter { $0.difficulty == filterString }
        } ?? worlds
        
        return filtered.map(WorldUIMapper.map)
    }
    
    // MARK: - Intentions
    func loadWorlds() async {
        isLoading = true
        
        let currentLangId = languageViewModel.activeLanguage?.id ?? 1
        
        do {
            async let easy = getHomeWorldsUseCase.execute(languageId: currentLangId, difficulty: "EASY")
            async let medium = getHomeWorldsUseCase.execute(languageId: currentLangId, difficulty: "MEDIUM")
            async let hard = getHomeWorldsUseCase.execute(languageId: currentLangId, difficulty: "HARD")
            
            let easyWorlds = (try? await easy) ?? []
            let mediumWorlds = (try? await medium) ?? []
            let hardWorlds = (try? await hard) ?? []
            
            worlds = easyWorlds + mediumWorlds + hardWorlds
        }
        
        isLoading = false
    }
    
    func selectFilter(_ filter: WorldDifficulty?) {
        selectedFilter = filter
    }
    
    func onWorldTapped(_ world: WorldUIModel) {
        guard !world.isLocked else { return }
        let currentLangId = languageViewModel.activeLanguage?.id ?? 1
        // Temporarily passing a hash of the id as the worldId until Worlds API uses integers
        router.push(.gameLevels(worldId: Int(world.id) ?? 10, worldName: world.title, languageId: currentLangId))
    }
    
    func onBackTapped() {
        router.pop()
    }
}
