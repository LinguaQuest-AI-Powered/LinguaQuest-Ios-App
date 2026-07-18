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
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Top App Bar Data
    var coins: String = "0"
    var gems: String = "0"
    
    // MARK: - Header Data
    var userName: String = ""
    var level: Int = 1
    var avatarImage: String? = nil
    
    // MARK: - Stats Data
    var totalXP: String = "0"
    var streak: String = "0"
    var worlds: String = "0"
    
    // MARK: - Learning Progress Data
    var currentLanguage: String = ""
    var journeyTitle: String = ""
    var languageLevel: String = ""
    var currentLanguageXP: Int = 0
    var targetLanguageXP: Int = 0
    
    // MARK: - Lists Data
    var achievements: [AchievementUIModel] = []
    var topExplorers: [ExplorerUIModel] = []
    
    // MARK: - Intentions (Methods)
    
    func navigateToSettings() {
        router.push(.settings)
    }
    
    // Mock fetch profile data method
    func fetchProfileData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            
            await MainActor.run {
                // Mock Data
                self.coins = "1,250"
                self.gems = "45"
                
                self.userName = "Explorer Alex"
                self.level = 12
                self.avatarImage = nil
                
                self.totalXP = "4,500"
                self.streak = "7 Days"
                self.worlds = "2"
                
                self.currentLanguage = L10n.Onboarding.languageFrench
                self.journeyTitle = "Intermediate Journey"
                self.languageLevel = "B1 LEVEL"
                self.currentLanguageXP = 2450
                self.targetLanguageXP = 3000
                
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
                
                self.isLoading = false
            }
        }
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
