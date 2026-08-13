//
//  ProfileView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(Router.self) private var router
    @State var viewModel: ProfileViewModel
    @State private var selectedAchievement: AchievementUIModel? = nil
    
    @AppStorage("hasSeenProfileTutorial") private var hasSeenProfileTutorial: Bool = false
    @State private var showTutorial: Bool = false
    @State private var tutorialBounds: [TutorialStepType: CGRect] = [:]
    
    private let tutorialSteps: [TutorialStepType] = [
        .yourProfile,
        .profileStats,
        .settings,
        .achievements,
        .leaderboard
    ]
    
    var body: some View {
        ZStack {
            Group {
                if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error: \(error)")
                            .appTextStyle(.bodyBold, color: .red)
                        Button("Retry") {
                            viewModel.fetchProfileData()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Color.appBackgroundWarm.ignoresSafeArea()
                    )
                } else {
                    ProfileContentView(
                        rawCoins: viewModel.statsService.coins,
                        rawXP: viewModel.statsService.xp,
                        coinsValue: viewModel.statsService.coins.formattedStatsValue(),
                        gemsValue: viewModel.gems,
                        userName: viewModel.userName,
                        userLevel: viewModel.level,
                        avatarImage: viewModel.avatarImage,
                        xpValue: viewModel.statsService.xp.formattedStatsValue(),
                        streakValue: "\(viewModel.statsService.streakDays.formattedStatsValue())",
                        worldsValue: viewModel.worlds,
                        languageName: viewModel.currentLanguage,
                        journeyTitle: viewModel.journeyTitle,
                        levelName: viewModel.languageLevel,
                        currentXP: viewModel.currentLanguageXP,
                        targetXP: viewModel.targetLanguageXP,
                        achievements: viewModel.achievements,
                        topExplorers: viewModel.topExplorers,
                        onEditProfile: {
                            viewModel.onEditPhotoTapped()
                        },
                        onViewAllAchievements: {
                            router.push(.achievements)
                        },
                        onViewAllExplorers: {
                            router.push(.leaderboard(languageId: viewModel.currentLanguageId))
                        },
                        onSettingsTapped: {
                            viewModel.navigateToSettings()
                        },
                        onAchievementTapped: { achievement in
                            selectedAchievement = achievement
                        }
                    )
                }
            }
            
            if viewModel.isUploadingPhoto {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.3)
                        .tint(.white)
                    
                    Text(L10n.EditProfile.uploadingPhoto)
                        .appTextStyle(.bodyBold, color: .white)
                }
                .padding(24)
                .background(Color.appSurfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 10)
            }
            
            if showTutorial {
                TutorialOverlayView(
                    bounds: tutorialBounds,
                    steps: tutorialSteps,
                    isPresented: $showTutorial
                )
            }
        }
        .coordinateSpace(name: "TutorialSpace")
        .onPreferenceChange(TutorialBoundsPreferenceKey.self) { bounds in
            self.tutorialBounds = bounds
        }
        .customBottomSheet(isPresented: Binding(
            get: { selectedAchievement != nil },
            set: { if !$0 { selectedAchievement = nil } }
        ), initialDetent: .custom(ratio: 0.68)) {
            if let achievement = selectedAchievement {
                AchievementDetailSheet(
                    title: achievement.title,
                    subtitle: achievement.subtitle,
                    uiIcon: achievement.uiIcon,
                    uiIconColor: achievement.uiIconColor,
                    status: achievement.status,
                    progressPercent: achievement.progressPercent,
                    xpReward: achievement.xpReward,
                    coinsReward: achievement.coinsReward,
                    earnedAt: achievement.earnedAt,
                    onClose: {
                        selectedAchievement = nil
                    }
                )
            }
        }
        .customBottomSheet(isPresented: $viewModel.showPhotoSourcePicker, initialDetent: .custom(ratio: 0.38)) {
            ProfilePhotoSourceBottomSheet(
                onCameraSelected: {
                    viewModel.selectSourceCamera()
                },
                onGallerySelected: {
                    viewModel.selectSourceGallery()
                },
                onCancelSelected: {
                    viewModel.showPhotoSourcePicker = false
                }
            )
        }
        .sheet(isPresented: $viewModel.showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                viewModel.uploadPhoto(image: image)
            }
        }
        .sheet(isPresented: $viewModel.showGalleryPicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                viewModel.uploadPhoto(image: image)
            }
        }
        .onAppear {
            viewModel.fetchProfileData()
            
            // Temporary for testing: always show tutorial
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showTutorial = true
            }
        }
    }
}

