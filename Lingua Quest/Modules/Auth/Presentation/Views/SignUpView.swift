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
            
            ScrollView(showsIndicators: false) {
                DialogCardContainer(mascotImage: .registerationBird) {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 8) {
                            Text(L10n.Auth.createYourAccount)
                                .appTextStyle(.displayLarge, color: .appTextSecondary)
                            
                            Text(L10n.Auth.createAccountDescription)
                                .appTextStyle(.body, color: .appTextSecondary)
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
                        }
                        
                        CustomButton(
                            type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                            text: L10n.Auth.createAccount,
                            action: { viewModel.createAccount() },
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
                            Text(L10n.Auth.alreadyHaveAccount)
                                .appTextStyle(.body, color: .appTextSecondary)
                            
                            Button(action: {
                                viewModel.navigateToLogin()
                            }) {
                                Text(L10n.Auth.logIn)
                                    .appTextStyle(.bodyBold, color: .appTextSecondary)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, 24)
            }
            VStack {
                HStack {
                    CustomBackButton(action: { viewModel.navigateToLogin() })
                    Spacer()
                }
                .padding(.horizontal, 24)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("LightTheme") {
    SignUpView(viewModel: SignUpViewModel(router: Router()))
}

#Preview("DarkTheme") {
    SignUpView(viewModel: SignUpViewModel(router: Router()))
        .preferredColorScheme(.dark)
}

