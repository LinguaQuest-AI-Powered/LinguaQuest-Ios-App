//
//  SettingsView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Properties
    @State var viewModel: SettingsViewModel
    @State private var showLogoutConfirm = false
    @State private var showRepeatPicker = false
    @State private var showMyLanguagesSheet = false
    @State private var showAddLanguageScreen = false
    
    // MARK: - Body
    var body: some View {
        SettingsContentView(
            viewModel: viewModel,
            onBackTapped: {
                viewModel.onBackTapped()
            },
            onEditProfileTapped: {
                viewModel.onEditProfileTapped()
            },
            onLearningLanguageTapped: {
                showMyLanguagesSheet = true
            },
            onAppLanguageTapped: {
                viewModel.onAppLanguageTapped()
            },
            onHelpTapped: {
                viewModel.onHelpTapped()
            },
            onAboutTapped: {
                viewModel.onAboutTapped()
            },
            onLogOutTapped: {
                showLogoutConfirm = true
            },
            onRepeatTapped: {
                showRepeatPicker = true
            }
        )
        .navigationBarHidden(true)
        .appDialog(isPresented: Binding(get: { viewModel.activationState == .checking || viewModel.activationState == .loading }, set: { _ in })) {
            SharedImageLoadingView(
                imageAsset: .loadingBird,
                title: L10n.Common.loading,
                subtitle: ""
            )
        }
        .appToast(
            isPresented: $viewModel.showToast,
            type: viewModel.toastType,
            title: viewModel.toastTitle,
            subtitle: viewModel.toastSubtitle
        )
        .customBottomSheet(isPresented: $showRepeatPicker, initialDetent: .custom(ratio: 0.55)) {
            RepeatSelectionBottomSheet(
                repeatDays: $viewModel.reminderRepeatDays,
                onSave: { showRepeatPicker = false }
            )
        }
        .appDialog(isPresented: Binding(get: { viewModel.isLoggingOut }, set: { _ in })) {
            SharedImageLoadingView(
                imageAsset: .logoutBird,
                title: L10n.Settings.logOut,
                subtitle: L10n.Common.loading,
                imageSize: 160
            )
        }
        .appDialog(isPresented: $showLogoutConfirm) {
            LogoutConfirmDialog(
                onConfirm: {
                    showLogoutConfirm = false
                    viewModel.logOut()
                },
                onCancel: {
                    showLogoutConfirm = false
                }
            )
        }
        .appDialog(isPresented: $viewModel.showActivationDialog) {
            ActivationConfirmDialog(
                viewModel: viewModel,
                onConfirm: {
                    viewModel.confirmActivation()
                },
                onCancel: {
                    viewModel.showActivationDialog = false
                    viewModel.isLockScreenVocabularyEnabled = false
                }
            )
        }
        .appDialog(isPresented: $viewModel.showNotEnoughCoins) {
            NotEnoughCoinsDialog(
                title: L10n.Game.notEnoughCoinsTitle,
                subtitle: L10n.Game.notEnoughCoinsSubtitle,
                missingCoins: viewModel.missingCoins,
                currentCoins: viewModel.currentCoins,
                action: {
                    viewModel.showNotEnoughCoins = false
                    viewModel.isLockScreenVocabularyEnabled = false
                }
            )
        }
        .customBottomSheet(isPresented: $showMyLanguagesSheet, initialDetent: .custom(ratio: 0.7)) {
            MyLanguagesBottomSheet(
                languageViewModel: viewModel.languageViewModel,
                isPresented: $showMyLanguagesSheet,
                onAddNewLanguage: {
                    showAddLanguageScreen = true
                }
            )
        }
        .fullScreenCover(isPresented: $showAddLanguageScreen) {
            AddLanguageView(languageViewModel: viewModel.languageViewModel)
        }
        .onAppear {
            viewModel.refreshAppLanguage()
            Task {
                await viewModel.languageViewModel.loadMyLanguages()
            }
        }
    }
}

// MARK: - Preview
