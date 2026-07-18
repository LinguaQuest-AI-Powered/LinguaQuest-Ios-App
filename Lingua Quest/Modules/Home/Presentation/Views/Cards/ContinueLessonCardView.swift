//
//  ContinueLessonCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI


struct ContinueLessonCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.Home.continueLessonTitle)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(Color.appTextSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.appBackgroundWarm)
                        )
                    
                    Text(L10n.Home.lessonApple)
                        .font(AppTextStyle.displayMedium.font)
                    
                    Text(L10n.Home.lessonAppleDesc)
                        .font(AppTextStyle.bodyMedium.font)
                        .foregroundColor(Color.appTextPrimary)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.appBackgroundWarm)
                        .frame(width: 96, height: 96)
                    
                    Image(asset: .appleImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                    Text(L10n.Home.continueButton)
                        .font(AppTextStyle.bodyLargeMedium.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.appBrandPrimary)
                .clipShape(Capsule())
            }
        }
        .padding(18)
        .background(Color.appSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}


#Preview {
    ContinueLessonCardView()
}
