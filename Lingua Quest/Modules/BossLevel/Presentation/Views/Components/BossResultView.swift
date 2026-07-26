

import SwiftUI

struct BossResultView: View {
    let result: BossEvaluationResult
    let onCloseTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemIcon: result.task_completed ? .starFill : .xmarkSealFill)
                .font(.system(size: 80))
                .foregroundColor(result.task_completed ? .appGlowGold : .appAccentRed)
                .padding()
                .background(Circle().fill(Color.appSurfaceCard))
                .shadow(radius: 10)
            
            Text(result.task_completed ? L10n.BossLevel.objectiveComplete : L10n.BossLevel.objectiveFailed)
                .appTextStyle(.headingLarge, color: result.task_completed ? .appSemanticSuccess : .appSemanticError)
            
            VStack(spacing: 8) {
                Text(L10n.BossLevel.fluencyScore(result.fluency_score))
                    .appTextStyle(.headingMedium, color: .appTextHeading)
                
                Text(result.feedback_message)
                    .appTextStyle(.bodyLarge, color: .appTextPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.appSurfaceCard))
            .padding(.horizontal)
            
            Spacer()
            
            CustomButton(type: .primary, text: L10n.BossLevel.resultFinish, action: onCloseTapped, status: .enable)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackgroundWarm.ignoresSafeArea())
    }
}
