//
//  VoicePracticeCardView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoicePracticeCardView: View {
    var completed: Int
    var total: Int
    var action: () -> Void
    
    private var progressFraction: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
    
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
                                    .frame(width: proxy.size.width * progressFraction, height: 10)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progressFraction)
                            }
                        }
                        .frame(height: 10)
                        
                        Text(L10n.Home.voicePracticeProgress(completed: completed, total: total))
                            .font(AppTextStyle.captionMedium.font)
                            .foregroundColor(.appBrandBrown)
                    }
                    .padding(.top, 4)
                }
                
                Spacer()
                
                ZStack {
                    // Refined rounded background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appAccentOrange.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.appAccentOrange.opacity(0.3), lineWidth: 1.5)
                        )
                        .shadow(color: Color.appAccentOrange.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    Image(asset: .micBird)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 68, height: 68)
                        .offset(y: 4)
                }
                .frame(width: 80, height: 80)
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
        VoicePracticeCardView(completed: 2, total: 5, action: {})
            .padding()
    }
}
