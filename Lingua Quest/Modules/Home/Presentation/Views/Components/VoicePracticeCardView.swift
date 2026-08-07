//
//  VoicePracticeCardView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoicePracticeCardView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var completed: Int
    var total: Int
    var action: () -> Void
    
    @State private var shimmerOffset: CGFloat = -200
    @State private var buttonGlow = false
    
    private var progressFraction: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appAccentOrange.opacity(0.1))
                    .frame(height: 90)
                
                Image(asset: .micBird)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 76)
                    .offset(y: 4)
            }
            .frame(maxWidth: .infinity)
            
            Text(L10n.Home.voicePracticeTitle)
                .font(AppTextStyle.bodyLargeMedium.font)
                .foregroundColor(.appTextHeading)
                .lineLimit(1)
            
            Text(L10n.Home.voicePracticeSubtitle)
                .font(AppTextStyle.micro.font)
                .foregroundColor(.appTextSecondary)
                .lineLimit(1)
            
            VStack(alignment: .leading, spacing: 6) {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.appAccentOrange.opacity(0.2))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(Color.appAccentOrange)
                            .frame(width: proxy.size.width * progressFraction, height: 8)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progressFraction)
                    }
                }
                .frame(height: 8)
                
                Text(L10n.Home.voicePracticeProgress(completed: completed, total: total))
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(.appBrandBrown)
            }
            
            Spacer(minLength: 0)
            
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                        .font(.system(size: 14, weight: .bold))
                    Text(L10n.Home.start)
                        .font(AppTextStyle.captionMedium.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        Capsule()
                            .fill(Color.appAccentOrange)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .white.opacity(0.2), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .mask(Capsule())
                    }
                )
                .clipShape(Capsule())
                .shadow(
                    color: Color.appAccentOrange.opacity(buttonGlow ? 0.45 : 0.2),
                    radius: buttonGlow ? 14 : 8,
                    x: 0, y: 4
                )
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurfaceCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.appBorderLight.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .onAppear { startAnimations() }
    }
    
    private func startAnimations() {
        guard !reduceMotion else { return }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.3)) {
            buttonGlow = true
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false).delay(1.0)) {
            shimmerOffset = 400
        }
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VoicePracticeCardView(completed: 2, total: 5, action: {})
            .padding()
    }
}
