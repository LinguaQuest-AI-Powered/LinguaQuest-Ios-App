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
                        coinsValue: viewModel.statsService.coins.formatted(),
                        gemsValue: viewModel.gems,
                        userName: viewModel.userName,
                        userLevel: viewModel.level,
                        avatarImage: viewModel.avatarImage,
                        xpValue: viewModel.statsService.xp.formatted(),
                        streakValue: "\(viewModel.statsService.streakDays) Days",
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
        }
    }
}

