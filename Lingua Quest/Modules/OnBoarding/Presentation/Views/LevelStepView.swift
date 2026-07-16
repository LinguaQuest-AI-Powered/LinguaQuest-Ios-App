//
//  LevelStepView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

import SwiftUI

struct LevelStepView: View {
    let state: OnboardingUiState
    let onSelectLevel: (UserLevel) -> Void
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(asset: .bird3)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            Text(L10n.Onboarding.levelStepTitle)
                .appTextStyle(.headline)
            
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
            
            Spacer()
            
            CustomButton(
                type: .primary,
                text: L10n.Onboarding.commonContinue,
                action: onContinue,
                status: state.canContinueFromLevel ? .enable : .disable,
                trailing: Image(systemName: "arrow.right")
            )
        }
        .padding(24)
        .background(Color.appSecondary.opacity(0.18))
    }
}



#Preview {
    LevelStepView(
        state: OnboardingUiState(),
        onSelectLevel: { _ in },
        onContinue: {}
    )
}
