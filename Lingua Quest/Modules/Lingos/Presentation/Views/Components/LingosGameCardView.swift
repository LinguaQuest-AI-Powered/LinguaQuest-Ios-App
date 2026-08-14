//
//  LingosGameCardView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 09/08/2026.
//

import SwiftUI

struct LingosGameCardView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let tagText: String
    let title: String
    let buttonText: String
    let mascotAsset: Image.Asset
    let tagColor: Color
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(tagText)
                        .font(AppTextStyle.microSemibold.font)
                        .foregroundColor(.appBrandBrown)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(tagColor.opacity(0.15))
                        )
                    
                    Text(title)
                        .font(AppTextStyle.headingMedium.font)
                        .foregroundColor(.appTextHeading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(tagColor.opacity(0.12))
                        .frame(width: 84, height: 84)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .shadow(color: tagColor.opacity(0.15), radius: 8, x: 0, y: 4)
                    
                    Image(asset: mascotAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                        .offset(y: 4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
            
            AppButton(
                text: buttonText,
                icon: .play,
                height: 52,
                action: action
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.appSurfaceCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.8), Color.appBorderLight.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}
