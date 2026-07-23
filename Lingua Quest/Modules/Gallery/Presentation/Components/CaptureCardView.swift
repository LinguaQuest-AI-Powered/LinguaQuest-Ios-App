//
//  CaptureCardView.swift
//  Lingua Quest
//

import SwiftUI

struct CaptureCardView: View {
    let item: CapturedItem
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ZStack(alignment: .topTrailing) {
                Group {
                    if let data = item.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(asset: Image.Asset(rawValue: item.image ?? "") ?? .apple)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appSurfaceCard.opacity(0.72), lineWidth: 2)
                )
                
                Text(item.category.uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(Color.appTealGreen)
                    )
                    .padding(8)
            }
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.englishName)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.appTextPrimary)
                    
                    Text(item.translatedName)
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(.appBrandBrown)
                }
                
                Spacer()
                
                if item.isCollected {
                    ZStack {
                        Circle()
                            .fill(Color.appSemanticSuccess)
                            .frame(width: 26, height: 26)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemIcon: .checkmark)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                else {
                    ZStack {
                        Circle()
                            .fill(Color.appRed)
                            .frame(width: 26, height: 26)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemIcon: .xmark)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.94 : 0.98))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.appBorderLight.opacity(colorScheme == .dark ? 0.6 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.20 : 0.08), radius: 14, x: 0, y: 8)
    }
}

#Preview {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        CaptureCardView(item: CapturedItem.mocks[0])
            .frame(width: 160)
    }
}
