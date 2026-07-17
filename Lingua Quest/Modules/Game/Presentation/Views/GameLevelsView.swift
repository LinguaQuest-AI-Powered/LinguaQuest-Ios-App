//
//  GameLevelsView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct GameLevelsView: View {
    @State var viewModel: GameLevelsViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var titleOpacity: Double = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // LAYER 1: Scrollable Map Area (Underneath everything, filling the screen)
            GeometryReader { geo in
                let w = geo.size.width
                let levelSpacing: CGFloat = 160
                let totalHeight = CGFloat(viewModel.levels.count) * levelSpacing + 200
                
                // We add a massive buffer of extra grass image to the top and bottom.
                // This means when you scroll past the limits (bounce), you just see more
                // of the same moving grass, and NEVER a black screen or static background.
                let overscrollBuffer: CGFloat = 800
                let paddedHeight = totalHeight + (overscrollBuffer * 2)
                
                ScrollViewReader { scrollProxy in
                    ScrollView(showsIndicators: false) {
                        ZStack(alignment: .topLeading) {
                            
                            // Road shadow (soft drop shadow under the road)
                            WindingRoadShape()
                                .stroke(Color.black.opacity(0.2), style: StrokeStyle(lineWidth: 52, lineCap: .round, lineJoin: .round))
                                .blur(radius: 6)
                                .offset(y: 4)
                                .frame(width: w, height: totalHeight)
                            
                            // Winding Road (Outer border)
                            WindingRoadShape()
                                .stroke(Color(red: 0.45, green: 0.3, blue: 0.12), style: StrokeStyle(lineWidth: 48, lineCap: .round, lineJoin: .round))
                                .frame(width: w, height: totalHeight)
                            
                            // Winding Road (Inner fill)
                            WindingRoadShape()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.78, green: 0.58, blue: 0.36),
                                            Color(red: 0.68, green: 0.48, blue: 0.28)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 36, lineCap: .round, lineJoin: .round)
                                )
                                .frame(width: w, height: totalHeight)
                            
                            // Winding Road (Dashed center line)
                            WindingRoadShape()
                                .stroke(Color.white.opacity(0.25), style: StrokeStyle(lineWidth: 2, dash: [12, 18]))
                                .frame(width: w, height: totalHeight)
                            
                            // Level Nodes
                            ForEach(Array(viewModel.levels.enumerated()), id: \.element.id) { index, level in
                                let yPos = totalHeight - 100 - (CGFloat(index) * levelSpacing)
                                let xPos = RoadMath.xPosition(for: yPos, in: w)
                                
                                LevelNodeView(level: level)
                                    .position(x: xPos, y: yPos)
                                    .id(level.id)
                            }
                            
                            // Floating sparkle particles for a magical feel
                            FloatingParticlesView(
                                width: w,
                                height: totalHeight,
                                particleCount: 25
                            )
                        }
                        .frame(width: w, height: totalHeight)
                        // Apply the tiled grass as a background that bleeds massively out of the ZStack's bounds!
                        .background(
                            ZStack(alignment: .topLeading) {
                                
                                // Custom Tiled Background with Crossfade to hide seams
                                let imageHeight: CGFloat = 1000
                                let overlap: CGFloat = 0.2 // 20% overlap
                                let stepHeight = imageHeight * (1.0 - overlap)
                                let imageCount = Int(paddedHeight / stepHeight) + 2
                                
                                ZStack {
                                    ForEach(0..<imageCount, id: \.self) { i in
                                        Image(asset: .gameLevelBackground)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: w, height: imageHeight)
                                            // Fade the bottom edge of each upper image to softly blend into the solid image below it
                                            .mask(
                                                LinearGradient(
                                                    stops: [
                                                        .init(color: .black, location: 0.0),
                                                        .init(color: .black, location: 1.0 - overlap),
                                                        .init(color: .clear, location: 1.0)
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .position(
                                                x: w / 2,
                                                y: paddedHeight - (CGFloat(i) * stepHeight) - (imageHeight / 2)
                                            )
                                            .zIndex(CGFloat(i))
                                    }
                                }
                                .frame(width: w, height: paddedHeight)
                                .offset(y: -overscrollBuffer)
                                
                                // Dark Mode Overlay
                                if colorScheme == .dark {
                                    Color.black.opacity(0.35)
                                        .frame(width: w, height: paddedHeight)
                                        .offset(y: -overscrollBuffer)
                                }
                            }
                        )
                    }
                    .onAppear {
                        // Automatically scroll to the absolute bottom (Level 1) when the screen opens
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            // We scroll to level 1 with a bottom anchor so the scrollview hits the very bottom edge
                            scrollProxy.scrollTo(viewModel.levels.first?.id ?? 1, anchor: .bottom)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
            // LAYER 2: Top Navigation Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemIcon: .chevronLeft)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        )
                }
                .scaleEffect(titleOpacity)
                
                Spacer()
                
                Text(L10n.Game.parkWorld)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    .opacity(titleOpacity)
                    .scaleEffect(titleOpacity == 0 ? 0.8 : 1.0)
                
                Spacer()
                
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 20)
            .background(
                LinearGradient(
                    stops: [
                        .init(color: Color.black.opacity(0.5), location: 0.0),
                        .init(color: Color.black.opacity(0.25), location: 0.6),
                        .init(color: Color.clear, location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .padding(.top, -100)
            )
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15)) {
                titleOpacity = 1
            }
        }
    }
}

#Preview {
    GameLevelsView(viewModel: GameLevelsViewModel())
}
