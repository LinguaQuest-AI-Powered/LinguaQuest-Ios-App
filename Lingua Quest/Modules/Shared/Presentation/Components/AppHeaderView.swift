//
//  AppHeaderView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 17/07/2026.
//

import SwiftUI

struct AppHeaderView: View {
    var starCount: Int
    var coinCount: Int
    
    var body: some View {
        
        HStack(spacing: 8) {
            Image(.bird)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .padding(6)
                .background(Circle().fill(Color.white))
                .overlay(Circle().stroke(Color.brown, lineWidth: 2))
            
            Text("LinguaQuest")
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            
            Spacer()
            
            StatBadge(image: .xpIcon, value: starCount, iconBackground: .white)
            StatBadge(image: .coinsIcon, value: coinCount, iconBackground: .brown)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(
            Color(red: 0.99, green: 0.95, blue: 0.91)
                .ignoresSafeArea(edges: .top)
        )
    }

}

struct StatBadge: View {
    let image: ImageResource
    let value: Int
    let iconBackground: Color
    
    private var formattedValue: String {
        if value >= 1_000_000 {
            let formatted = String(format: "%.1fM", Double(value) / 1_000_000)
            return formatted.replacingOccurrences(of: ".0M", with: "M")
        } else if value >= 10_000 {
            let formatted = String(format: "%.1fK", Double(value) / 1_000)
            return formatted.replacingOccurrences(of: ".0K", with: "K")
        } else {
            return "\(value)"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(iconBackground)
                    .frame(width: 22, height: 22)
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
            Text(formattedValue)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black.opacity(0.05), lineWidth: 1))
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
