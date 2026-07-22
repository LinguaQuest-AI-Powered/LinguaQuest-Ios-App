//
//  ScoreCircleView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct ScoreCircleView: View {
    let rating: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.appSurfaceCard)
                .frame(width: 120, height: 120)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                .overlay(
                    ZStack {
                        Circle()
                            .stroke(Color.appAccentOrange.opacity(0.2), lineWidth: 6)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(rating) / 10.0)
                            .stroke(Color.appAccentOrange, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                )
            
            VStack(spacing: 4) {
                Text("\(rating)/10")
                    .font(.system(size: 32, weight: .bold, design: .rounded)) // Similar to the large text in image
                    .foregroundColor(.appAccentOrange)
                
                Text(L10n.SpeakingLab.score)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.appTextSecondary)
            }
        }
    }
}

#Preview {
    ScoreCircleView(rating: 8)
        .padding()
        .background(Color.appBackgroundWarm)
}
