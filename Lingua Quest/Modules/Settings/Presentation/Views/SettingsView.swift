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
                // Navigate to Language Picker
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
            }
        )
        .navigationBarHidden(true)
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
    }
}

// MARK: - Preview
