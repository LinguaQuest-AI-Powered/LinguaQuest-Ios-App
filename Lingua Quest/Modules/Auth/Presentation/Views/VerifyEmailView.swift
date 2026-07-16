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
                        
                        Image(asset: .bird)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(.top, 16)
                            .zIndex(1)
                        
                        VStack(spacing: 24) {
                            
                            VStack(spacing: 16) {
                                Text(L10n.Auth.verifyYourEmail)
                                    .appTextStyle(.largeTitle, color: .textBrown)
                                    .multilineTextAlignment(.center)
                                
                                Text(L10n.Auth.verifyEmailDesc)
                                    .appTextStyle(.body, color: .textBrown)
                                    .opacity(0.8)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                            }
                            .padding(.top, 32)
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
                            }
                            .padding(.top, 8)
                            VStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    Image(systemIcon: .timer)
                                        .foregroundColor(.textBrown)
                                    Text(String(format: "00:%02d", viewModel.timeRemaining))
                                        .appTextStyle(.body, color: .textBrown)
                                }
                                
                                Button(action: {
                                    if viewModel.timeRemaining == 0 {
                                        viewModel.resendCode()
                                        isKeyboardShowing = true
                                    }
                                }) {
                                    Text(L10n.Auth.resendCode)
                                        .appTextStyle(.buttonBold, color: .darkGreen)
                                        .opacity(viewModel.timeRemaining == 0 ? 1.0 : 0.5)
                                }
                                .disabled(viewModel.timeRemaining > 0)
                            }
                            
                            CustomButton(
                                type: .primary,
                                text: L10n.Auth.verify,
                                action: { viewModel.verifyCode() },
                                trailing:  Image(systemIcon: .checkmarkCircleFill)
                            )
                            
                            Spacer(minLength: 40)
                            
                            Button(action: {
                                viewModel.navigateToLogin()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemIcon: .arrowLeft)
                                    Text(L10n.Auth.backToLogin)
                                }
                                .appTextStyle(.buttonBold, color: .darkGreen)
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isKeyboardShowing = true
            }
        }
    }
    
    @ViewBuilder
    private func otpCircle(index: Int) -> some View {
        let char = getOtpChar(at: index)
        let isFocused = viewModel.otpCode.count == index || (viewModel.otpCode.count == 4 && index == 3)
        let isFilled = viewModel.otpCode.count > index
        
        Circle()
            .stroke(isFocused ? Color.darkGreen : (isFilled ? Color.darkGreen.opacity(0.5) : Color.borderBrown.opacity(0.3)), lineWidth: isFocused ? 2 : 1)
            .frame(width: 60, height: 60)
            .background(Circle().fill(Color.white))
            .overlay(
                Text(char)
                    .appTextStyle(.largeTitle, color: .textBrown)
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

#Preview {
    VerifyEmailView(viewModel: VerifyEmailViewModel(router: Router()))
}
