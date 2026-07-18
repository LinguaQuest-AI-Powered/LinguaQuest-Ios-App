//
//  ProfileViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import Observation

@Observable
final class ProfileViewModel {
    // MARK: - State
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
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
    var achievements: [AchievementEntity] = []
    var topExplorers: [ExplorerEntity] = []
    
    // MARK: - Intentions (Methods)
    
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
                
                self.achievements = [
                    AchievementEntity(id: "1", title: "Wild Explorer", subtitle: "Complete 10 lessons in...", type: .wildExplorer),
                    AchievementEntity(id: "2", title: "Perfect Week", subtitle: "7 days streak without...", type: .perfectWeek)
                ]
                
                self.topExplorers = [
                    ExplorerEntity(id: "1", rank: 1, name: "Marco Polo", xp: 12450, avatarImage: nil),
                    ExplorerEntity(id: "2", rank: 2, name: "Amelia Earhart", xp: 11200, avatarImage: nil),
                    ExplorerEntity(id: "3", rank: 3, name: "Ibn Battuta", xp: 9850, avatarImage: nil)
                ]
                
                self.isLoading = false
            }
        }
    }
}
