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
            Color.appViewBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView(showsIndicators: false) {
                    DialogCardContainer(mascotImage: .bird) {
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
            .background(Circle().fill(Color.appCardBackground))
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
