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
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        viewModel.navigateToLogin()
                    }) {
                        Circle()
                            .fill(Color.borderLightBlue.opacity(0.3))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemIcon: .chevronLeft)
                                    .foregroundColor(Color.textBrown)
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .zIndex(2)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        Image(asset: .bird2)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(.top, 16)
                            .zIndex(1)
                        
                        VStack(spacing: 24) {
                            
                            VStack(spacing: 16) {
                                Text(L10n.Auth.forgetPassword)
                                    .appTextStyle(.largeTitle, color: .textBrown)
                                    .multilineTextAlignment(.center)
                                
                                Text(L10n.Auth.forgetPasswordDesc)
                                    .appTextStyle(.body, color: .textBrown)
                                    .opacity(0.8)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                            }
                            .padding(.top, 32)
                            
                            CustomTextField(
                                icon: .envelopeFill,
                                placeholder: L10n.Auth.enterEmail,
                                text: $viewModel.email
                            )
                            .padding(.top, 8)
                            
                            CustomButton(
                                type: .primary,
                                text: L10n.Auth.sendResetLink,
                                action: { viewModel.sendResetLink() },
                                trailing: Image(systemIcon: .arrowRight)
                            )
                            
                            Spacer(minLength: 40)
                            
                            Button(action: {
                                viewModel.navigateToLogin()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemIcon: .arrowLeft)
                                    Text(L10n.Auth.backToLogin)
                                }
                                .appTextStyle(.body, color: .appPrimary)
                            }
                            .padding(.bottom, 32)
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
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ForgetPasswordView(viewModel: ForgetPasswordViewModel(router: Router()))
}
