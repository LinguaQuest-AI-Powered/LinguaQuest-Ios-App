//
//  LoginView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 14/07/2026.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            
            Color.appBackgroundWarm.ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            ScrollView(showsIndicators: false) {
                DialogCardContainer(mascotImage: .loginBird) {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 8) {
                            Text(L10n.Auth.welcomeBack)
                                .dialogTitleStyle()
                            
                            Text(L10n.Auth.readyToContinue)
                                .dialogSubtitleStyle()
                                .opacity(0.8)
                        }
                        
                        VStack(spacing: 16) {
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
                            // Removed inline error message
                        }
                        
                        HStack {
                            Button(action: {
                                viewModel.forgotPassword()
                            }) {
                                Text(L10n.Auth.forgotPassword)
                                    .dialogSubtitleStyle()
                            }
                            Spacer()
                        }
                                                
                        CustomButton(
                            type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                            text: L10n.Auth.logIn,
                            action: { viewModel.login() },
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
                            Text(L10n.Auth.newHere)
                                .dialogSubtitleStyle()
                            
                            Button(action: {
                                viewModel.navigateToSignUp()
                            }) {
                                Text(L10n.Auth.signUp)
                                    .dialogSubtitleStyle()
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
            .scrollDismissesKeyboard(.interactively)
            
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
}

#Preview("LightTheme") {
    LoginView(viewModel: .preview)
}

#Preview("DarkTheme") {
    LoginView(viewModel: .preview)
            .preferredColorScheme(.dark)
}
