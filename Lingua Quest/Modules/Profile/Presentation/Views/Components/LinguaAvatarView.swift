//
//  LinguaAvatarView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct LinguaAvatarView: View {
    // MARK: - Properties
    var imageName: String?
    var size: CGFloat = 112
    var showBadge: Bool = false
    var badgeIcon: Image.SystemIcon = .pencil
    var onBadgeTapped: (() -> Void)? = nil
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            Group {
                if let imageName = imageName, !imageName.isEmpty {
                    if (imageName.hasPrefix("http://") || imageName.hasPrefix("https://")), let url = URL(string: imageName) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(.user1)
                                    .resizable()
                                    .scaledToFill()
                            @unknown default:
                                Image(.user1)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                    } else {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                    }
                } else {
                    // Default Fallback Image
                    Image(.user1)
                        .resizable()
                        .scaledToFill()
                }
            }


            .frame(width: size, height: size)
            .background(Color.appSurfaceCard)
            .clipShape(Circle())
            .padding(size * 0.035)
            .background(Color.appSurfaceCard)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.appBrandPrimary, lineWidth: size * 0.035))
            .shadow(color: .black.opacity(0.1), radius: size * 0.08, y: size * 0.08)
            
            // Optional Badge / Edit Icon
            if showBadge {
                Button(action: {
                    onBadgeTapped?()
                }) {
                    Image(systemIcon: badgeIcon)
                        
                        .font(.system(size: size * 0.12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: size * 0.28, height: size * 0.28)
                        .background(Color.appBrandBrownDark)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.appBackgroundWarm, lineWidth: 2))
                }
                .offset(x: 0, y: 0)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        LinguaAvatarView(
            imageName: nil,
            size: 112,
            showBadge: true,
            badgeIcon: .pencil
        ) {
            print("Edit Tapped!")
        }
        
        LinguaAvatarView(
            imageName: nil,
            size: 48,
            showBadge: false
        )
    }
}
