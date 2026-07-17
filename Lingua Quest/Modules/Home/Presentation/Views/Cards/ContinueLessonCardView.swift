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
                        .foregroundColor(Color.appTextBrown)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.appViewBackground)
                        )
                    
                    Text(L10n.Home.lessonApple)
                        .font(AppTextStyle.title.font)
                        .foregroundColor(.black)
                    
                    Text(L10n.Home.lessonAppleDesc)
                        .font(AppTextStyle.buttonMedium.font)
                        .foregroundColor(Color.appTextDarkBlue)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.appViewBackground)
                        .frame(width: 96, height: 96)
                    
                    Image(asset: .apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                    Text(L10n.Home.continueButton)
                        .font(AppTextStyle.subtitleMedium.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.appPrimaryColor)
                .clipShape(Capsule())
            }
        }
        .padding(18)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}


#Preview {
    ContinueLessonCardView()
}
