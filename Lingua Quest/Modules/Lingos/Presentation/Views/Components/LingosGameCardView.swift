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
                    RoundedRectangle(cornerRadius: 16)
                        .fill(tagColor.opacity(0.1))
                        .frame(width: 76, height: 76)
                    
                    Image(asset: mascotAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .offset(y: 4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            CustomButton(
                type: .custom(textColor: .white, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
                text: buttonText,
                action: action,
                leading: Image(systemIcon: .play)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurfaceCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.appBorderLight.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}
