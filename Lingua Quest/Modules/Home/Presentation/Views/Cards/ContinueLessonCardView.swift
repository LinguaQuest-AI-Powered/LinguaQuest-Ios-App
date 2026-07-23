//
//  ContinueLessonCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI


struct ContinueLessonCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var floatArtwork = false
    
    let title: String
    let lessonName: String
    let lessonDescription: String
    let imageAsset: Image.Asset
    let buttonText: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(Color.appTextSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.appSurfaceCardWarm.opacity(colorScheme == .dark ? 0.35 : 1.0))
                        )
                    
                    Text(lessonName)
                        .font(AppTextStyle.displayMedium.font)
                        .foregroundColor(Color.appTextHeading)
                    
                    Text(lessonDescription)
                        .font(AppTextStyle.bodyMedium.font)
                        .foregroundColor(Color.appTextPrimary)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.appSurfaceCardWarm.opacity(colorScheme == .dark ? 0.25 : 1.0))
                        .frame(width: 96, height: 96)
                    
                    Image(asset: imageAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .offset(y: floatArtwork ? -4 : 2)
                }
            }
            
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                    Text(buttonText)
                        .font(AppTextStyle.bodyLargeMedium.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [.appBrandPrimary, .appAccentOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.24 : 0.18), radius: 12, x: 0, y: 6)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.95 : 0.98))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.appBorderLight.opacity(colorScheme == .dark ? 0.62 : 0.78), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.22 : 0.08), radius: 18, x: 0, y: 10)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                floatArtwork = true
            }
        }
    }
}


#Preview {
    ContinueLessonCardView(
        title: L10n.Home.continueLessonTitle,
        lessonName: L10n.Home.lessonApple,
        lessonDescription: L10n.Home.lessonAppleDesc,
        imageAsset: .appleLogo,
        buttonText: L10n.Home.continueButton,
        action: {}
    )
}
