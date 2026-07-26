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
    @State private var showLanguagePicker = false
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
                showLanguagePicker = true
            },
            onHelpTapped: {
                // Navigate to Help & Support
            },
            onAboutTapped: {
                // Navigate to About App
            },
            onLogOutTapped: {
                showLogoutConfirm = true
            },
            onRepeatTapped: {
                showRepeatPicker = true
            }
        )
        .navigationBarHidden(true)
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
        .appDialog(isPresented: $showLanguagePicker) {
            LanguageSelectDialog(
                onSelectEnglish: {
                    viewModel.appLanguageCode = "en"
                    showLanguagePicker = false
                },
                onSelectArabic: {
                    viewModel.appLanguageCode = "ar"
                    showLanguagePicker = false
                },
                onCancel: {
                    showLanguagePicker = false
                }
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
                missingCoins: viewModel.missingCoins,
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
            Task {
                await viewModel.languageViewModel.loadMyLanguages()
            }
        }
    }
}

// MARK: - Preview
