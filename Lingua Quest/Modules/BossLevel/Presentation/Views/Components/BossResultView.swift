//
//  BossResultView.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import SwiftUI

struct BossResultView: View {
    let result: BossEvaluationResult
    let onCloseTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: result.task_completed ? "star.fill" : "xmark.seal.fill")
                .font(.system(size: 80))
                .foregroundColor(result.task_completed ? .yellow : .red)
                .padding()
                .background(Circle().fill(Color.appSurfaceCard))
                .shadow(radius: 10)
            
            Text(result.task_completed ? "Objective Complete!" : "Objective Failed")
                .appTextStyle(.headingLarge, color: result.task_completed ? .appSemanticSuccess : .appSemanticError)
            
            VStack(spacing: 8) {
                Text("Fluency Score: \(result.fluency_score)%")
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
            
            CustomButton(type: .primary, text: "Finish", action: onCloseTapped, status: .enable)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackgroundWarm.ignoresSafeArea())
    }
}
