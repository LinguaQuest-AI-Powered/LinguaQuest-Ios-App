//
//  LearningCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI


struct LearningCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(asset: .spanish)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 46, height: 46)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appBorderBrown, lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Home.currentlyLearning)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(Color.appTextSecondary)
                    
                    Text(L10n.Onboarding.languageSpanish)
                        .font(AppTextStyle.cardTitle.font)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(L10n.Home.level(12))
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(Color.appTextSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemIcon: .flameFill)
                            .foregroundColor(Color.red)
                        
                        Text(L10n.Home.daysStreak(7))
                            .font(AppTextStyle.captionMedium.font)
                    }
                }
            }
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appSecondaryProgressBar)
                    .frame(height: 10)
                
                Capsule()
                    .fill(Color.appProgressBar)
                    .frame(width: 165, height: 10)
            }
        }
        .padding(18)
        .background(Color.appSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}


#Preview {
    LearningCardView()
}
