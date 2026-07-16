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
            Color.white.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    Image(asset: .registerationBird)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.top, 40)
                        .zIndex(1)
                    
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 8) {
                            Text(L10n.Auth.createYourAccount)
                                .appTextStyle(.largeTitle, color: .textBrown)
                            
                            Text(L10n.Auth.createAccountDescription)
                                .appTextStyle(.body, color: .textBrown)
                                .opacity(0.8)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 32)
                        
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
                            type: .primary,
                            text: L10n.Auth.createAccount,
                            action: { viewModel.createAccount() },
                            trailing: Image(systemIcon: .arrowRight)
                                
                        )
                        .padding(.top, 8)
                        
                        
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(Color.borderBrown.opacity(0.5))
                                .frame(height: 1)
                            
                            Text(L10n.Auth.orContinueWith)
                                .appTextStyle(.body, color: .textBrown)
                                .opacity(0.6)
                                .layoutPriority(1)
                                .fixedSize(horizontal: true, vertical: false)
                            
                            Rectangle()
                                .fill(Color.borderBrown.opacity(0.5))
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
                        
                        Spacer(minLength: 32)
                        
                        HStack(spacing: 4) {
                            Text(L10n.Auth.alreadyHaveAccount)
                                .appTextStyle(.body, color: .textBrown)
                            
                            Button(action: {
                                viewModel.navigateToLogin()
                            }) {
                                Text(L10n.Auth.logIn)
                                    .appTextStyle(.buttonBold, color: .textBrown)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(LinearGradient(
                                colors: [Color.backgroundLightBlue.opacity(0.8), Color.white, Color.glowYellow.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.borderLightBlue.opacity(0.5), lineWidth: 1)
                            )
                    )
                    .offset(y: -40)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView(viewModel: SignUpViewModel(router: Router()))
}
