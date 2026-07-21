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
    
    // MARK: - State
    var isLoading: Bool = false
    var selectedFilter: WorldDifficulty? = nil
    private var worlds: [WorldItem] = []
    
    // MARK: - Init
    init(router: RouterProtocol) {
        self.router = router
        loadWorlds()
    }
    
    // MARK: - UI Model
    var displayWorlds: [WorldUIModel] {
        let filtered = selectedFilter.map { filter in
            worlds.filter { $0.difficulty == filter }
        } ?? worlds
        
        return filtered.map(WorldUIMapper.map)
    }
    
    // MARK: - Intentions
    func loadWorlds() {
        isLoading = true
        
        // Mock data — will be replaced by a real use case once the backend is wired in
        worlds = [
            WorldItem(id: "kitchen", title: L10n.Home.kitchenWorld, imageAssetName: "kitchen", difficulty: .easy, progress: 0.40, isCompleted: false),
            WorldItem(id: "city", title: L10n.Home.cityWorld, imageAssetName: "city", difficulty: .medium, progress: 0.10, isCompleted: false),
            WorldItem(id: "park", title: L10n.Worlds.parkWorld, imageAssetName: "kitchen", difficulty: .easy, progress: 1.0, isCompleted: true),
            WorldItem(id: "market", title: L10n.Worlds.marketWorld, imageAssetName: "kitchen", difficulty: .medium, progress: 0.0, isCompleted: false),
            WorldItem(id: "airport", title: L10n.Worlds.airportWorld, imageAssetName: "kitchen", difficulty: .hard, progress: 0.0, isCompleted: false, unlockLevel: 15),
            WorldItem(id: "school", title: L10n.Worlds.schoolWorld, imageAssetName: "kitchen", difficulty: .medium, progress: 0.65, isCompleted: false)
        ]
        
        isLoading = false
    }
    
    func selectFilter(_ filter: WorldDifficulty?) {
        selectedFilter = filter
    }
    
    func onWorldTapped(_ world: WorldUIModel) {
        guard !world.isLocked else { return }
        // Temporarily passing a hash of the id as the worldId until Worlds API uses integers
        router.push(.gameLevels(worldId: 10, worldName: world.title, languageId: 1))
    }
    
    func onBackTapped() {
        router.pop()
    }
}
