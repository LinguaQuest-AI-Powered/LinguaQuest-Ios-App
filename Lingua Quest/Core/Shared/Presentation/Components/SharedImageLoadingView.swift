//
//  SharedImageEvaluatingView.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import SwiftUI

struct SharedImageLoadingView: View {
    let imageAsset: Image.Asset
    let title: String
    let subtitle: String
    
    @State private var isAnalyzingPulsing = false
    @State private var isImageFloating = false
    
    var body: some View {
        DialogCardContainer(showMascot: false) {
            VStack(spacing: 28) {
                // Image container with shadow and circular frame
                ZStack {
                    Circle()
                        .fill(Color.appLoadingBackground) // Adaptive color from Assets
                        .overlay(
                            Circle()
                                .stroke(Color.appLoadingBorder, lineWidth: 8) // White border in light, dark in dark mode
                        )
                        .frame(width: 250, height: 250)
                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                    
                    Image(asset: imageAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .offset(y: isImageFloating ? -5 : 5)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isImageFloating)
                }
                
                VStack(spacing: 12) {
                    Text(title)
                        .dialogTitleStyle()
                        .multilineTextAlignment(.center)
                        .scaleEffect(isAnalyzingPulsing ? 1.05 : 0.95)
                        .opacity(isAnalyzingPulsing ? 1.0 : 0.7)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnalyzingPulsing)
                    
                    Text(subtitle)
                        .dialogSubtitleStyle()
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
            isImageFloating = true
        }
    }
}
