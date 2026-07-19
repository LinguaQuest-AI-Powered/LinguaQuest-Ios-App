//
//  ProfileViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import Observation
import SwiftUI

@Observable
final class ProfileViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    
    // MARK: - State
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    // MARK: - Top App Bar Data
    var coins: String = "1,250"
    var gems: String = "45"
    
    // MARK: - Header Data
    var userName: String = "Explorer Alex"
    var level: Int = 12
    var avatarImage: String? = nil
    
    // MARK: - Stats Data
    var totalXP: String = "4,500"
    var streak: String = "7 Days"
    var worlds: String = "2"
    
    // MARK: - Learning Progress Data
    var currentLanguage: String = L10n.Onboarding.languageFrench
    var journeyTitle: String = "Intermediate Journey"
    var languageLevel: String = "B1 LEVEL"
    var currentLanguageXP: Int = 2450
    var targetLanguageXP: Int = 3000
    
    // MARK: - Lists Data
    var achievements: [AchievementUIModel] = []
    var topExplorers: [ExplorerUIModel] = []
    
    init(router: RouterProtocol) {
        self.router = router
        
        // Map Mock Lists in initializer
        let rawAchievements = [
            AchievementEntity(id: "1", title: "Wild Explorer", subtitle: "Complete 10 lessons in...", type: .wildExplorer),
            AchievementEntity(id: "2", title: "Perfect Week", subtitle: "7 days streak without...", type: .perfectWeek)
        ]
        self.achievements = rawAchievements.map { self.mapAchievementToUIModel($0) }
        
        let rawExplorers = [
            ExplorerEntity(id: "1", rank: 1, name: "Marco Polo", xp: 12450, avatarImage: nil),
            ExplorerEntity(id: "2", rank: 2, name: "Amelia Earhart", xp: 11200, avatarImage: nil),
            ExplorerEntity(id: "3", rank: 3, name: "Ibn Battuta", xp: 9850, avatarImage: nil)
        ]
        self.topExplorers = rawExplorers.map { self.mapExplorerToUIModel($0) }
    }
    
    // MARK: - Intentions (Methods)
    
    func navigateToSettings() {
        router.push(.settings)
    }
    
    // Mock fetch profile data method - does nothing now since data is set in init
    func fetchProfileData() {
        // No action needed, data loads instantly
    }
    
    // MARK: - Mappers
    private func mapAchievementToUIModel(_ entity: AchievementEntity) -> AchievementUIModel {
        let uiIcon: Image.SystemIcon
        let uiIconColor: Color
        let uiBgColor: Color
        
        switch entity.type {
        case .wildExplorer:
            uiIcon = .trophyFill
            uiIconColor = .appBrandBrown
            uiBgColor = .appSurfaceCardWarm
        case .perfectWeek:
            uiIcon = .starFill
            uiIconColor = .appAccentTeal
            uiBgColor = .white
        }
        
        return AchievementUIModel(
            id: entity.id,
            title: entity.title,
            subtitle: entity.subtitle,
            uiIcon: uiIcon,
            uiIconColor: uiIconColor,
            uiBgColor: uiBgColor
        )
    }
    
    private func mapExplorerToUIModel(_ entity: ExplorerEntity) -> ExplorerUIModel {
        return ExplorerUIModel(
            id: entity.id,
            name: entity.name,
            uiRank: "\(entity.rank)",
            uiXPAmount: L10n.Profile.explorerXP(entity.xp.formatted()),
            avatarImage: entity.avatarImage,
            isTop: entity.rank == 1
        )
    }
}
