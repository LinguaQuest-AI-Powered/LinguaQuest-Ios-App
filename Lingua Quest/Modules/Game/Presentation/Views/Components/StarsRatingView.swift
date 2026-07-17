//
//  StarsRatingView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct StarsRatingView: View {
    let stars: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                Image(asset: index < stars ? .star2 : .star)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
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
