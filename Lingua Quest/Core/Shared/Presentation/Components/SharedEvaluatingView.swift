//
//  SharedEvaluatingView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct SharedEvaluatingView: View {
    let videoAsset: Video.Asset
    let title: String
    let subtitle: String
    
    @State private var isAnalyzingPulsing = false
    
    var body: some View {
        DialogCardContainer(showMascot: false) {
            VStack(spacing: 28) {
                // Video container with shadow and circular frame
                ZStack {
                    Circle()
                        .fill(Color.appSurfaceCard)
                        .frame(width: 250, height: 250)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                    
                    LoopedVideoPlayerView(videoAsset: videoAsset)
                        .frame(width: 230, height: 230)
                        .clipShape(Circle())
                }
                
                VStack(spacing: 12) {
                    Text(title)
                        .appTextStyle(.displayMedium, color: .appBrandBrown)
                        .scaleEffect(isAnalyzingPulsing ? 1.05 : 0.95)
                        .opacity(isAnalyzingPulsing ? 1.0 : 0.7)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnalyzingPulsing)
                    
                    Text(subtitle)
                        .appTextStyle(.body, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
        .onAppear {
            isAnalyzingPulsing = true
        }
    }
}
