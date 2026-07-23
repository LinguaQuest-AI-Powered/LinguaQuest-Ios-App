//
//  ResetPasswordView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 16/07/2026.
//

import SwiftUI

struct ResetPasswordView: View {
    @Bindable var viewModel: ResetPasswordViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView(showsIndicators: false) {
                    DialogCardContainer(mascotImage: currentMascotImage) {
                        VStack(spacing: 24) {
                            
                            VStack(spacing: 8) {
                                Text(L10n.Auth.newPasswordTitle)
                                    .appTextStyle(.displayLarge, color: .appTextSecondary)
                                    .multilineTextAlignment(.center)
                                
                                Text(L10n.Auth.newPasswordDesc)
                                    .appTextStyle(.body, color: .appTextSecondary)
                                    .opacity(0.8)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(L10n.Auth.newPasswordLabel)
                                    .appTextStyle(.bodyBold, color: .appTextPrimary)
                                
                                CustomSecureField(
                                    icon: .keyFill,
                                    placeholder: L10n.Auth.newPasswordPlaceholder,
                                    text: $viewModel.newPassword,
                                    isVisible: $viewModel.isNewPasswordVisible
                                )
                                
                                Text(L10n.Auth.passwordStrength)
                                    .appTextStyle(.caption, color: .appTextSecondary)
                                    .padding(.top, 4)
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.appBackgroundPrimary)
                                            .frame(height: 8)
                                        
                                        Capsule()
                                            .fill(passwordStrengthColor(for: viewModel.passwordStrengthProgress))
                                            .frame(width: max(0, geometry.size.width * viewModel.passwordStrengthProgress), height: 8)
                                            .animation(.easeInOut, value: viewModel.passwordStrengthProgress)
                                    }
                                }
                                .frame(height: 8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(L10n.Auth.confirmNewPasswordLabel)
                                    .appTextStyle(.bodyBold, color: .appTextPrimary)
                                
                                CustomSecureField(
                                    icon: .lockFill,
                                    placeholder: L10n.Auth.confirmNewPasswordPlaceholder,
                                    text: $viewModel.confirmNewPassword,
                                    isVisible: $viewModel.isConfirmNewPasswordVisible
                                )
                            }
                            
                            // Removed inline error message
                            
                            CustomButton(
                                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                                text: L10n.Auth.resetPassword,
                                action: {
                                    viewModel.resetPassword()
                                },
                                trailing: Image(systemIcon: .arrowRight),
                                isLoading: false
                            )
                            .padding(.top, 8)
                        }
                        .animation(.easeInOut, value: viewModel.errorMessage)
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            VStack {
                HStack {
                    CustomBackButton(action: {
                        viewModel.navigateToLogin()
                    })
                    Spacer()
                }
                .padding(.horizontal, 24)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .authLoadingOverlay(isLoading: viewModel.isLoading)
        .alert(
            L10n.Common.error,
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button(L10n.Common.ok) {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    private func passwordStrengthColor(for progress: Double) -> Color {
        if progress <= 0.33 {
            return .red
        } else if progress <= 0.66 {
            return .yellow
        } else {
            return .green
        }
    }
    
    private var currentMascotImage: Image.Asset {
        if viewModel.newPassword.isEmpty {
            return .resetPasswordBird
        } else if viewModel.passwordStrengthProgress < 1.0 {
            return .weakPasswordBird
        } else {
            return .strongPasswordBird
        }
    }
}


#Preview("LightTheme") {
    ResetPasswordView(viewModel: .preview)
}

#Preview("DarkTheme") {
    ResetPasswordView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
