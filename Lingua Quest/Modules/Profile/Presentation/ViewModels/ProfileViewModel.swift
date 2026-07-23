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
    
    // MARK: - State
    var isLoading: Bool = false
    var isUploadingPhoto: Bool = false
    var errorMessage: String? = nil
    var showPhotoSourcePicker: Bool = false
    var showCameraPicker: Bool = false
    var showGalleryPicker: Bool = false
    
    // MARK: - Top App Bar Data
    var coins: String = "0"
    var gems: String = "0"
    var rawCoins: Int = 0
    var rawXP: Int = 0
    
    // MARK: - Header Data
    var userName: String = ""
    var level: Int = 1
    var avatarImage: String? = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
    
    // MARK: - Stats Data
    var totalXP: String = "0"
    var streak: String = "0 Days"
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
        uploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol? = nil
    ) {
        self.router = router
        self.getProfileUseCase = getProfileUseCase
        self.uploadProfilePhotoUseCase = uploadProfilePhotoUseCase
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
                    self.avatarImage = photoUrl
                    UserDefaults.standard.set(photoUrl, forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
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
            self.avatarImage = avatarUrl
            UserDefaults.standard.set(avatarUrl, forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
        } else {
            self.avatarImage = "user1"
            UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
        }


        
        self.coins = profile.coins.formatted()
        self.rawCoins = profile.coins
        self.totalXP = profile.totalXp.formatted()
        self.rawXP = profile.totalXp
        self.streak = "\(profile.streakDays) Days"
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

// MARK: - UIImage Extension
private extension UIImage {
    func resizedForAvatar(maxDimension: CGFloat = 512) -> UIImage {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return self }
        
        let ratio = maxDimension / maxSide
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

