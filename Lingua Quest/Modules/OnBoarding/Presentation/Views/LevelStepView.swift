//
//  LevelStepView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LevelStepView: View {
    let state: OnboardingUiState
    let onSelectLevel: (UserLevel) -> Void
    let onContinue: () -> Void
    var onBack: (() -> Void)? = nil
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Image(asset: .bird3)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    Text(L10n.Onboarding.levelStepTitle)
                        .appTextStyle(.headline,color: .black)
                      
                    Text(L10n.Onboarding.levelStepSubtitle)
                        .appTextStyle(.subtitle, color: .secondaryButtonText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        ).overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    Color.appSecondary ,
                                    lineWidth: 1
                                )
                        )
                    
                    VStack(spacing: 14) {
                        ForEach(UserLevel.allCases) { level in
                            LevelCard(
                                level: level,
                                isSelected: state.selectedLevel == level,
                                action: { onSelectLevel(level) }
                            )
                        }
                    }
                }
                .padding(24)
            }
            
            VStack {
                CustomButton(
                    type: .primary,
                    text: L10n.Onboarding.commonContinue,
                    action: onContinue,
                    status: state.canContinueFromLevel ? .enable : .disable,
                    trailing: Image(systemIcon: .arrowRight),
                    disabledAction: { showAlert = true }
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.appSecondary.opacity(0.18))
        .alert(L10n.Onboarding.alertErrorTitle, isPresented: $showAlert) {
            Button(L10n.Common.ok, role: .cancel) { }
        } message: {
            Text(L10n.Onboarding.alertLevelMessage)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let onBack {
                    CustomBackButton(action: onBack)
                }
            }
        }
    }
}



#Preview {
    LevelStepView(
        state: OnboardingUiState(),
        onSelectLevel: { _ in },
        onContinue: {}
    )
}
