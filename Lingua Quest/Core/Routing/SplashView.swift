//
//  SplashView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 09/08/2026.
//

import SwiftUI

struct SplashView: View {
    @State private var currentFrameIndex = 0
    @State private var birdOffsetY: CGFloat = -80
    
    // The sequence of 10 images
    private let frames = (1...10).map { "lingo_splash_\($0)" }
    
    var body: some View {
        GeometryReader { geometry in
            let usableWidth = geometry.size.width - 40 // Padding horizontal 20
            
            ZStack {
                // Match exact color of LaunchScreen.storyboard
                Color(red: 4/255, green: 115/255, blue: 125/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Center Circle and Bird
                    ZStack {
                        Image("linguaquest_circle") // The NEW circle background
                            .resizable()
                            .scaledToFit()
                            .frame(width: usableWidth, height: usableWidth)
                        
                        Image(frames[currentFrameIndex]) // The animated mascot
                            .resizable()
                            .scaledToFit()
                            .frame(width: usableWidth * 0.72)
                            .offset(y: birdOffsetY) // Centered horizontally, only animating vertically
                    }
                    
                    Spacer()
                        .frame(height: 50) // Gap between Circle and Logo
                    
                    // Logo
                    Image("linguaQuest") // Logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: usableWidth * 0.88)
                    
                    Spacer()
                }
                .padding(.bottom, 80) // Pushes the entire layout upwards
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Frame-by-frame bird animation matching the Android coroutine logic
        Task {
            // Initial delay
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            for index in 0..<frames.count - 1 {
                try? await Task.sleep(nanoseconds: 120_000_000)
                await MainActor.run {
                    currentFrameIndex = index + 1
                    
                    switch currentFrameIndex {
                    case 0: birdOffsetY = -80
                    case 1: birdOffsetY = -60
                    case 2: birdOffsetY = -40
                    case 3: birdOffsetY = -20
                    case 4: birdOffsetY = -10
                    default: birdOffsetY = 0
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
