//
//  ForgetPasswordView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//

import SwiftUI

struct ForgetPasswordView: View {
    @State var viewModel: ForgetPasswordViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView(showsIndicators: false) {
                    DialogCardContainer(mascotImage: .forgetPasswordBird) {
                        VStack(spacing: 24) {
                            
                            VStack(spacing: 16) {
                                Text(L10n.Auth.forgetPassword)
                                    .appTextStyle(.displayLarge, color: .appTextSecondary)
                                    .multilineTextAlignment(.center)
                                
                                Text(L10n.Auth.forgetPasswordDesc)
                                    .appTextStyle(.body, color: .appTextSecondary)
                                    .opacity(0.8)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                            }
                            
                            CustomTextField(
                                icon: .envelopeFill,
                                placeholder: L10n.Auth.enterEmail,
                                text: $viewModel.email
                            )
                            .padding(.top, 8)
                            
                            if let errorMessage = viewModel.errorMessage {
                                HStack(spacing: 8) {
                                    Image(systemIcon: .exclamationmarkTriangleFill)
                                        .foregroundColor(.appSemanticError)
                                    Text(errorMessage)
                                        .appTextStyle(.captionMedium, color: .appSemanticError)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(12)
                                .background(Color.appSemanticError.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.appSemanticError.opacity(0.3), lineWidth: 1)
                                )
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            
                            CustomButton(
                                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                                text: L10n.Auth.sendResetLink,
                                action: { viewModel.sendResetLink() },
                                trailing: Image(systemIcon: .arrowRight),
                                isLoading: viewModel.isLoading
                            )
                        }
                        .animation(.easeInOut, value: viewModel.errorMessage)
                    }
                    .padding(.horizontal, 24)
                }
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
    ForgetPasswordView(viewModel: .preview)
}

#Preview("DarkTheme") {
    ForgetPasswordView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
