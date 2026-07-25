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
    private let getProfileUseCase: GetProfileUseCaseProtocol?
    private let uploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol?
    let statsService: StatsService
    
    // MARK: - State
    var isLoading: Bool = false
    var isUploadingPhoto: Bool = false
    var errorMessage: String? = nil
    var showPhotoSourcePicker: Bool = false
    var showCameraPicker: Bool = false
    var showGalleryPicker: Bool = false
    
    // MARK: - Top App Bar Data
    var gems: String = "0"

    
    // MARK: - Header Data
    var userName: String = ""
    var level: Int = 1
    var avatarImage: String? = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
    
    // MARK: - Stats Data
    var worlds: String = "0"
    
    // MARK: - Learning Progress Data
    var currentLanguage: String = ""
    var journeyTitle: String = ""
    var languageLevel: String = ""
    var currentLanguageId: Int = 0
    var currentLanguageXP: Int = 0
    var targetLanguageXP: Int = 0
    
    // MARK: - Lists Data
    var achievements: [AchievementUIModel] = []
    var topExplorers: [ExplorerUIModel] = []
    
    init(
        router: RouterProtocol,
        getProfileUseCase: GetProfileUseCaseProtocol? = nil,
        uploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol? = nil,
        statsService: StatsService
    ) {
        self.router = router
        self.getProfileUseCase = getProfileUseCase
        self.uploadProfilePhotoUseCase = uploadProfilePhotoUseCase
        self.statsService = statsService
    }
    
    // MARK: - Intentions (Methods)
    
    func navigateToSettings() {
        router.push(.settings)
    }
    
    func onEditPhotoTapped() {
        showPhotoSourcePicker = true
    }
    
    func selectSourceCamera() {
        showPhotoSourcePicker = false
        showCameraPicker = true
    }
    
    func selectSourceGallery() {
        showPhotoSourcePicker = false
        showGalleryPicker = true
    }
    
    func uploadPhoto(image: UIImage) {
        let resizedImage = image.resizedForAvatar(maxDimension: 512)
        guard let uploadProfilePhotoUseCase = uploadProfilePhotoUseCase,
              let imageData = resizedImage.jpegData(compressionQuality: 0.8) else { return }
        
        let mimeType = "image/jpeg"
        
        isUploadingPhoto = true
        errorMessage = nil
        
        Task {
            do {
                let photoUrl = try await uploadProfilePhotoUseCase.execute(imageData: imageData, mimeType: mimeType)
                await MainActor.run {
                    let fullUrl = AppConfig.resolveURL(photoUrl)
                    self.avatarImage = fullUrl
                    UserDefaults.standard.set(fullUrl, forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
                    self.isUploadingPhoto = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isUploadingPhoto = false
                }
            }
        }
    }

    
    func fetchProfileData() {

        guard let getProfileUseCase = getProfileUseCase else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let profile = try await getProfileUseCase.execute()
                await MainActor.run {
                    self.populateData(from: profile)
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func populateData(from profile: UserProfileEntity) {
        self.userName = profile.username
        self.level = profile.level
        if let avatarUrl = profile.avatarUrl, !avatarUrl.isEmpty {
            let fullUrl = AppConfig.resolveURL(avatarUrl)
            self.avatarImage = fullUrl
            UserDefaults.standard.set(fullUrl, forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
        } else {
            self.avatarImage = "user1"
            UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
        }

        statsService.syncBalances(coins: profile.coins, xp: profile.totalXp, streakDays: profile.streakDays)
        
        self.worlds = "\(profile.worldsCount)"
        
        self.currentLanguage = profile.currentLanguageName
        self.journeyTitle = profile.journeyLabel
        self.languageLevel = "LEVEL \(profile.currentLanguageLevel)"
        self.currentLanguageId = profile.currentLanguageId
        self.currentLanguageXP = profile.currentXp
        self.targetLanguageXP = profile.nextMilestoneXp
        
        self.achievements = profile.achievements.map { self.mapAchievementToUIModel($0) }
        self.topExplorers = profile.topExplorers.map { self.mapExplorerToUIModel($0) }
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
            isTop: entity.rank == 1,
            isCurrentUser: entity.isCurrentUser
        )
    }
}



