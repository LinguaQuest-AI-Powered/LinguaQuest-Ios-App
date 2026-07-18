//
//  CaptureCardView.swift
//  Lingua Quest
//

import SwiftUI

struct CaptureCardView: View {
    let item: CapturedItem
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .topTrailing) {
                
                Rectangle()
                    .fill(Color(red: 0.9, green: 0.85, blue: 0.8))
                    .overlay(
                        Image(asset: Image.Asset(rawValue: item.image) ?? .apple)
                            .resizable()
                            .scaledToFill()
                    )
                    .clipped()
                    .border(Color.white, width: 7)
                
                
                Text(item.category.uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.2, green: 0.5, blue: 0.45))
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    .padding([.top, .trailing], 10)
            }
            .frame(height: 140)
            
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.englishName)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    
                    Text(item.translatedName)
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(.brown)
                }
                
                Spacer()
                
                if item.isCollected {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.5, blue: 0.45))
                            .frame(width: 26, height: 26)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemIcon: .checkmark)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                else {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.8, green: 0.3, blue: 0.3))
                            .frame(width: 26, height: 26)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemIcon: .xmark)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        CaptureCardView(item: CapturedItem.mocks[0])
            .frame(width: 160)
    }
}
