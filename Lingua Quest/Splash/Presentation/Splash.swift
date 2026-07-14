//
//  Splash.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 14/07/2026.
//

import SwiftUI

//TODO: Wire to core

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.55, blue: 0.60),
                    Color(red: 0.00, green: 0.35, blue: 0.38)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Image("linguaQuest")
                .resizable()
                .scaledToFit()
                .frame(width: 338, height: 338)
                .position(x:200, y: 120)
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 260, height: 260)
                
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 4)
                    .frame(width: 264, height: 264)
                    .shadow(color: Color.black, radius: 10, x: 0, y: 20)

                
                Image("bird")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .position(x:190, y: 385)
                
            }.position(x:200, y: 330)
            
            
            Image("star")
                .position(x: 45, y: 200)
            
            Image("star")
                .position(x: 330, y: 430)
            
            
            Text("LinguaQuest")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .position(x: 200, y: 600)
        
        }
    }
}


#Preview {
    SplashView()
}
