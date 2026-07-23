//
//  VerifyEmailView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//

import SwiftUI

struct VerifyEmailView: View {
    @State var viewModel: VerifyEmailViewModel
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView(showsIndicators: false) {
                    DialogCardContainer(mascotImage: .verifyEmailBird) {
                        VStack(spacing: 24) {
                            
                            VStack(spacing: 16) {
                                Text(L10n.Auth.verifyYourEmail)
                                    .appTextStyle(.displayLarge, color: .appTextSecondary)
                                    .multilineTextAlignment(.center)
                                
                                Text(L10n.Auth.verifyEmailDesc)
                                    .appTextStyle(.body, color: .appTextSecondary)
                                    .opacity(0.8)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                            }
                            ZStack {
                                HStack(spacing: 16) {
                                    ForEach(0..<4, id: \.self) { index in
                                        otpCircle(index: index)
                                    }
                                }
                                
                                TextField("", text: $viewModel.otpCode)
                                    .keyboardType(.numberPad)
                                    .textContentType(.oneTimeCode)
                                    .focused($isKeyboardShowing)
                                    .foregroundColor(.clear)
                                    .accentColor(.clear)
                                    .onChange(of: viewModel.otpCode) { _, newValue in
                                        if newValue.count > 4 {
                                            viewModel.otpCode = String(newValue.prefix(4))
                                        }
                                    }
                            }
                            .padding(.top, 8)
                            
                            // Removed inline error message
                            VStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    Image(systemIcon: .timer)
                                        .foregroundColor(.appTextSecondary)
                                    Text(String(format: "00:%02d", viewModel.timeRemaining))
                                        .appTextStyle(.body, color: .appTextSecondary)
                                }
                                
                                Button(action: {
                                    if viewModel.timeRemaining == 0 {
                                        viewModel.resendCode()
                                        isKeyboardShowing = true
                                    }
                                }) {
                                    Text(L10n.Auth.resendCode)
                                        .appTextStyle(.bodyBold, color: .appSemanticSuccess)
                                        .opacity(viewModel.timeRemaining == 0 ? 1.0 : 0.5)
                                }
                                .disabled(viewModel.timeRemaining > 0)
                            }
                            
                            CustomButton(
                                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                                text: L10n.Auth.verify,
                                action: { viewModel.verifyCode() },
                                trailing:  Image(systemIcon: .checkmarkCircleFill),
                                isLoading: false
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isKeyboardShowing = true
            }
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
    
    @ViewBuilder
    private func otpCircle(index: Int) -> some View {
        let char = getOtpChar(at: index)
        let isFocused = viewModel.otpCode.count == index || (viewModel.otpCode.count == 4 && index == 3)
        let isFilled = viewModel.otpCode.count > index
        
        Circle()
            .stroke(isFocused ? Color.appSemanticSuccess : (isFilled ? Color.appSemanticSuccess.opacity(0.5) : Color.appBorderBrown.opacity(0.3)), lineWidth: isFocused ? 2 : 1)
            .frame(width: 60, height: 60)
            .background(Circle().fill(Color.appSurfaceCard))
            .overlay(
                Text(char)
                    .appTextStyle(.displayLarge, color: .appTextSecondary)
            )
            .onTapGesture {
                isKeyboardShowing = true
            }
    }
    
    private func getOtpChar(at index: Int) -> String {
        guard index < viewModel.otpCode.count else { return "" }
        let startIndex = viewModel.otpCode.index(viewModel.otpCode.startIndex, offsetBy: index)
        return String(viewModel.otpCode[startIndex])
    }
}

#Preview("LightTheme") {
    VerifyEmailView(viewModel: .preview)
}

#Preview("DarkTheme") {
    VerifyEmailView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
