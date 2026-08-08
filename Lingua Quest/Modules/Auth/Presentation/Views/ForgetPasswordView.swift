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
            
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        Spacer(minLength: 80)
                        
                        DialogCardContainer(mascotImage: .forgetPasswordBird) {
                            VStack(spacing: 24) {
                                
                                VStack(spacing: 16) {
                                    Text(L10n.Auth.forgetPassword)
                                        .dialogTitleStyle()
                                        .multilineTextAlignment(.center)
                                    
                                    Text(L10n.Auth.forgetPasswordDesc)
                                        .dialogSubtitleStyle()
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
                                
                                // Removed inline error message
                                CustomButton(
                                    type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                                    text: L10n.Auth.sendResetLink,
                                    action: { viewModel.sendResetLink() },
                                    trailing: Image(systemIcon: .arrowRight),
                                    isLoading: false
                                )
                            }
                            .animation(.easeInOut, value: viewModel.errorMessage)
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                    }
                    .frame(minHeight: geometry.size.height)
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
    }
}

#Preview("LightTheme") {
    ForgetPasswordView(viewModel: .preview)
}

#Preview("DarkTheme") {
    ForgetPasswordView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
