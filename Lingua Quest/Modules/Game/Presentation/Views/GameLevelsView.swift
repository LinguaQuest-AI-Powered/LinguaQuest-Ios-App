//
//  GameLevelsView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct GameLevelsView: View {
    @State var viewModel: GameLevelsViewModel
    var worldName: String
    var worldId: Int
    var languageId: Int
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(Router.self) var router
    @State private var titleOpacity: Double = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // LAYER 1: Scrollable Map Area (Underneath everything, filling the screen)
            GeometryReader { geo in
                let w = geo.size.width
                let levelSpacing: CGFloat = 160
                // Enforce a minimum of 6 items so the road always reaches the bottom of the screen, even if the API returns fewer levels.
                let itemsCount = max(viewModel.levels.isEmpty ? 6 : viewModel.levels.count, 6)
                let totalHeight = CGFloat(itemsCount) * levelSpacing + 200
                
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
                            if viewModel.isLoading {
                                ForEach(0..<itemsCount, id: \.self) { index in
                                    let yPos = totalHeight - 100 - (CGFloat(index) * levelSpacing)
                                    let xPos = RoadMath.xPosition(for: yPos, in: w)
                                    
                                    GameLoadingNodeView(index: index)
                                        .position(x: xPos, y: yPos)
                                        .id(index)
                                }
                            } else {
                                ForEach(Array(viewModel.levels.enumerated()), id: \.element.id) { index, level in
                                    let yPos = totalHeight - 100 - (CGFloat(index) * levelSpacing)
                                    let xPos = RoadMath.xPosition(for: yPos, in: w)
                                    
                                    Button {
                                        router.push(.cameraQuestTask)
                                    } label: {
                                        LevelNodeView(level: level)
                                    }
                                    .buttonStyle(.plain)
                                    .position(x: xPos, y: yPos)
                                    .id(level.id)
                                }
                            }
                            
                            // Permanent invisible anchor at the absolute bottom of the road
                            Color.clear
                                .frame(width: 1, height: 1)
                                .position(x: w / 2, y: totalHeight)
                                .id("bottom_anchor")
                            
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
                            Group {
                                let imageHeight: CGFloat = 1000
                                let overlap: CGFloat = 0.2 // 20% overlap
                                let stepHeight = imageHeight * (1.0 - overlap)
                                let imageCount = Int(paddedHeight / stepHeight) + 2
                                
                                LazyVStack(spacing: -imageHeight * overlap) {
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
                                            .zIndex(Double(-i))
                                    }
                                }
                                .offset(y: -overscrollBuffer)
                                .overlay(
                                    colorScheme == .dark ? Color.black.opacity(0.35) : Color.clear
                                )
                            },
                            alignment: .top
                        )
                    }
                    .onChange(of: viewModel.isLoading) { _, isLoading in
                        if !isLoading {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                scrollProxy.scrollTo("bottom_anchor", anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: viewModel.levels) { _, newLevels in
                        if !newLevels.isEmpty {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                scrollProxy.scrollTo("bottom_anchor", anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        // Immediately scroll to the bottom anchor of the road when view appears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            scrollProxy.scrollTo("bottom_anchor", anchor: .bottom)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .task {
                await viewModel.fetchLevels(worldId: worldId, languageId: languageId)
            }
            
            // LAYER 2: Top Navigation Bar
            HStack {
                CustomBackButton(action: { dismiss() })
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    )
                    .scaleEffect(titleOpacity)
                
                Spacer()
                
                Text(worldName)
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

// #Preview("LightTheme") {
//     // Requires mock GetGameLevelsUseCase
//     // GameLevelsView(viewModel: GameLevelsViewModel(...), worldName: "Park World", worldId: 10)
// }
// 
// #Preview("DarkTheme") {
//     // GameLevelsView(viewModel: GameLevelsViewModel(...), worldName: "Park World", worldId: 10)
//     //     .preferredColorScheme(.dark)
// }
