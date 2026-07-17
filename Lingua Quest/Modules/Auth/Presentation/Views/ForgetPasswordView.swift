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
            Color.appViewBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView(showsIndicators: false) {
                    DialogCardContainer(mascotImage: .forgetPasswordBird) {
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
                            
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButton(action: { viewModel.navigateToLogin() })
            }
        }
    }
}

#Preview {
    ForgetPasswordView(viewModel: ForgetPasswordViewModel(router: Router()))
}
