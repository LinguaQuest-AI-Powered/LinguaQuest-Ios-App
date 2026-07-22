//
//  VoicePracticeCardView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoicePracticeCardView: View {
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.Home.voicePracticeTitle)
                        .font(AppTextStyle.displaySmall.font)
                        .foregroundColor(.appTextHeading)
                    
                    Text(L10n.Home.voicePracticeSubtitle)
                        .font(AppTextStyle.bodyMedium.font)
                        .foregroundColor(.appTextSecondary)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.appAccentOrange.opacity(0.2))
                                    .frame(height: 10)
                                
                                Capsule()
                                    .fill(Color.appAccentOrange)
                                    .frame(width: proxy.size.width * 0.6, height: 10)
                            }
                        }
                        .frame(height: 10)
                        
                        Text(L10n.Home.voicePracticeProgress(completed: 3, total: 5))
                            .font(AppTextStyle.captionMedium.font)
                            .foregroundColor(.appBrandBrown)
                    }
                    .padding(.top, 4)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appAccentOrange.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Image(asset: .micBird)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .offset(y: 4) // Adjust if the bird needs to sit at the bottom, or remove offset
                }
            }
            
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                        .font(.system(size: 16, weight: .bold))
                    Text(L10n.Home.start)
                        .font(AppTextStyle.bodyBold.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appAccentOrange)
                .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(Color.appSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VoicePracticeCardView(action: {})
            .padding()
    }
}
