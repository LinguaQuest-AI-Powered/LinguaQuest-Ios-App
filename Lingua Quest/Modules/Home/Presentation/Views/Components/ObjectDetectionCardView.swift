//
//  ObjectDetectionCardView.swift
//  Lingua Quest
//
//  Created by siam on 06/08/2026.
//

import SwiftUI

struct ObjectDetectionCardView: View {
    var completed: Int
    var total: Int
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottom) {
                // Background image
                Image(asset: .heroSection)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 380)
                    .overlay(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.4),
                                .init(color: Color.appSurfaceCard.opacity(0.6), location: 0.75),
                                .init(color: Color.appSurfaceCard, location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipped()
                
                // Content overlay
                VStack(spacing: 16) {
                    // Texts
                    VStack(spacing: 8) {
                        Text(L10n.Home.objectDetectionTitle)
                            .appTextStyle(.headingLarge, color: .appTextHeading)
                            .multilineTextAlignment(.center)
                            .shadow(color: Color.appSurfaceCard, radius: 4, x: 0, y: 0)
                            .shadow(color: Color.appSurfaceCard, radius: 4, x: 0, y: 0)
                        
                        Text(L10n.Home.objectDetectionSubtitle)
                            .appTextStyle(.bodyLargeBold, color: .appTextHeading.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .shadow(color: Color.appSurfaceCard, radius: 4, x: 0, y: 0)
                    }
                    
                    // Action Button
                    ZStack {
                        Circle()
                            .fill(Color.appBrandBrown)
                            .frame(width: 76, height: 76)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 5)
                            )
                            .shadow(color: Color.appBrandBrown.opacity(0.4), radius: 10, x: 0, y: 6)
                        
                        Image(systemIcon: .camera)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
            .background(Color.appSurfaceCard)
            .cornerRadius(28)
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.6), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(HomeScaleButtonStyle())
    }
}
