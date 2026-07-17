//
//  StarsRatingView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct StarsRatingView: View {
    let stars: Int
    @State private var animatedStars: [Bool] = [false, false, false]
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                Image(asset: index < stars ? .star2 : .star)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .scaleEffect(animatedStars[index] ? 1.0 : 0.0)
                    .rotationEffect(animatedStars[index] ? .zero : .degrees(-30))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)
        )
        .onAppear {
            for i in 0..<3 {
                withAnimation(
                    .spring(response: 0.4, dampingFraction: 0.5)
                    .delay(0.5 + Double(i) * 0.12)
                ) {
                    animatedStars[i] = true
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StarsRatingView(stars: 0)
        StarsRatingView(stars: 1)
        StarsRatingView(stars: 2)
        StarsRatingView(stars: 3)
    }
    .padding()
    .background(Color.gray)
}
