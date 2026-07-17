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
    
    var body: some View {
        GeometryReader { screenGeo in
            ZStack(alignment: .top) {
                // The scaled canvas
                ZStack {
                    Image(asset: .gameLevelBackground)
                        .resizable()
                    
                    // Darken background slightly in dark mode for better contrast
                    Color.black.opacity(colorScheme == .dark ? 0.35 : 0)
                    
                    // Nodes mapped perfectly on the background
                    GeometryReader { mapGeo in
                        ForEach(viewModel.levels) { level in
                            LevelNodeView(level: level)
                                .position(
                                    x: mapGeo.size.width * level.proportionalPosition.x,
                                    y: mapGeo.size.height * level.proportionalPosition.y
                                )
                        }
                    }
                }
                .aspectRatio(390/885, contentMode: .fill)
                .frame(width: screenGeo.size.width, height: screenGeo.size.height)
                .clipped()
                
                // Top Navigation Bar
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.appPrimary)
                                .frame(width: 38, height: 38)
                                .background(Circle().fill(Color.appCardBackground))
                                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                        }
                        
                        Spacer()
                        
                        Text(L10n.Game.parkWorld)
                            .appTextStyle(.title, color: .appTextBrown)
                        
                        Spacer()
                        
                        // Empty view to balance the HStack
                        Color.clear
                            .frame(width: 38, height: 38)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, screenGeo.safeAreaInsets.top + 16)
                    .padding(.bottom, 8)
                    // Soft background gradient for the top bar to make text readable over map
                    .background(
                        LinearGradient(
                            colors: [
                                Color.appViewBackground.opacity(0.95),
                                Color.appViewBackground.opacity(0.7),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    GameLevelsView(viewModel: GameLevelsViewModel())
}
