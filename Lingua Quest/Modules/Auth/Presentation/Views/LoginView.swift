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
            
            ScrollView(showsIndicators: false) {
                DialogCardContainer(mascotImage: .loginBird) {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 8) {
                            Text(L10n.Auth.welcomeBack)
                                .appTextStyle(.displayLarge, color: .appTextSecondary)
                            
                            Text(L10n.Auth.readyToContinue)
                                .appTextStyle(.body, color: .appTextSecondary)
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
                        }
                        
                        HStack {
                            Button(action: {
                                viewModel.forgotPassword()
                            }) {
                                Text(L10n.Auth.forgotPassword)
                                    .appTextStyle(.bodyBold, color: .appSemanticSuccess)
                            }
                            Spacer()
                        }
                                                
                        CustomButton(
                            type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                            text: L10n.Auth.logIn,
                            action: { viewModel.login() },
                            trailing: Image(systemIcon: .arrowRight)
                        )
                        .padding(.top, 8)
                        
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(Color.appBorderBrown.opacity(0.5))
                                .frame(height: 1)
                            
                            Text(L10n.Auth.orContinueWith)
                                .appTextStyle(.body, color: .appTextSecondary)
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
                                .appTextStyle(.body, color: .appTextSecondary)
                            
                            Button(action: {
                                viewModel.navigateToSignUp()
                            }) {
                                Text(L10n.Auth.signUp)
                                    .appTextStyle(.bodyBold, color: .appTextSecondary)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview("LightTheme") {
    LoginView(viewModel: LoginViewModel(router: Router(), userPreferences: UserPreferences()))
}

#Preview("DarkTheme") {
    LoginView(viewModel: LoginViewModel(router: Router(), userPreferences: UserPreferences()))
        .preferredColorScheme(.dark)
}
