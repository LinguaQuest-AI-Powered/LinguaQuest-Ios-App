//
//  MyCapturesHeaderView.swift
//  Lingua Quest
//

import SwiftUI

struct MyCapturesHeaderView: View {
    @State private var isBouncing = false
    var objectsCollected: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                Image(asset: .myCaptureBird)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(8)
                    .background(Circle().fill(Color(red: 0.99, green: 0.78, blue: 0.52)))
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .scaleEffect(isBouncing ? 1.05 : 0.95)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            isBouncing = true
                        }
                    }
                
                ZStack {
                    Circle()
                        .fill(Color(red: 0.2, green: 0.5, blue: 0.45))
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    
                    Image(systemIcon: .cameraFill)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: 2, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.Gallery.myCaptures)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                
                Text(objectsCollected == 0 ? L10n.Gallery.capturesSoFar : L10n.Gallery.objectsCollected(objectsCollected))
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

#Preview {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        MyCapturesHeaderView(objectsCollected: 24)
    }
}
