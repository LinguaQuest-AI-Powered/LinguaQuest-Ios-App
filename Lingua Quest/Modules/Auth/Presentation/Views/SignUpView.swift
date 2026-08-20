//
//  SignUpView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//

import SwiftUI

struct SignUpView: View {
    @State var viewModel: SignUpViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            ScrollView(showsIndicators: false) {
                DialogCardContainer(mascotImage: .registerationBird) {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 8) {
                            Text(L10n.Auth.createYourAccount)
                                .dialogTitleStyle()
                                .multilineTextAlignment(.center)
                            
                            Text(L10n.Auth.createAccountDescription)
                                .dialogSubtitleStyle()
                                .opacity(0.8)
                                .multilineTextAlignment(.center)
                        }
                        
                        VStack(spacing: 16) {
                            CustomTextField(
                                icon: .personFill,
                                placeholder: L10n.Auth.usernamePlaceholder,
                                text: $viewModel.username
                            )
                            
                            CustomTextField(
                                icon: .envelopeFill,
                                placeholder: L10n.Auth.emailPlaceholder,
                                text: $viewModel.email
                            )
                            
                            CustomSecureField(
                                icon: .lockFill,
                                placeholder: L10n.Auth.passwordPlaceholder,
                                text: $viewModel.password,
                                isVisible: $viewModel.isPasswordVisible
                            )
                            
                            CustomSecureField(
                                icon: .lockFill,
                                placeholder: L10n.Auth.confirmPasswordPlaceholder,
                                text: $viewModel.confirmPassword,
                                isVisible: $viewModel.isConfirmPasswordVisible
                            )
                            // Removed inline error message
                        }
                        
                        CustomButton(
                            type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                            text: L10n.Auth.createAccount,
                            action: { viewModel.createAccount() },
                            trailing: Image(systemIcon: .arrowRight),
                            isLoading: false
                        )
                        .padding(.top, 8)
                        
                        
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(Color.appBorderBrown.opacity(0.5))
                                .frame(height: 1)
                            
                            Text(L10n.Auth.orContinueWith)
                                .dialogSubtitleStyle()
                                .opacity(0.6)
                                .layoutPriority(1)
                                .fixedSize(horizontal: true, vertical: false)
                            
                            Rectangle()
                                .fill(Color.appBorderBrown.opacity(0.5))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        VStack(spacing: 16) {
                            SocialLoginButton(
                                icon: .google,
                                title: L10n.Auth.googleLabel,
                                action: { viewModel.continueWithGoogle() }
                            )
                            
                            SocialLoginButton(
                                icon: .apple,
                                title: L10n.Auth.appleLabel,
                                action: { viewModel.continueWithApple() }
                            )
                        }
                        
                        HStack(spacing: 4) {
                            Text(L10n.Auth.alreadyHaveAccount)
                                .dialogSubtitleStyle()
                            
                            Button(action: {
                                viewModel.navigateToLogin()
                            }) {
                                Text(L10n.Auth.logIn)
                                    .dialogSubtitleStyle()
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .padding(.top, 64)
            }
            .scrollDismissesKeyboard(.interactively)
            VStack {
                HStack {
                    CustomBackButton(action: { viewModel.navigateBack() })
                    Spacer()
                }
                .padding(.horizontal, 24)
                Spacer()
            }
            
        }
        .onChange(of: viewModel.isLoading) { _, isLoading in
            if isLoading {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .appDialog(isPresented: $viewModel.isLoading) {
            SharedImageLoadingView(
                imageAsset: .loadng,
                title: L10n.Common.loading,
                subtitle: ""
            )
        }
        .navigationBarBackButtonHidden(true)
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
        .appToast(
            isPresented: $viewModel.showSuccessToast,
            type: .success,
            title: L10n.Auth.accountCreatedTitle,
            subtitle: L10n.Auth.accountCreatedSubtitle
        )
    }
}

#Preview("LightTheme") {
    SignUpView(viewModel: .preview)
}

#Preview("DarkTheme") {
    SignUpView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
