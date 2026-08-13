//
//  CoinFlyAnimationView.swift
//  Lingua Quest
//
//  Created by taqieallah on 13/08/2026.
//

import SwiftUI

struct CoinFlyParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var opacity: Double
    var rotation: Double
    var animationDelay: Double
    var animationDuration: Double
}

struct CoinFlyAnimationView: View {
    let startPoint: CGPoint
    let endPoint: CGPoint
    @State private var particles: [CoinFlyParticle] = []
    
    let coinCount = 12
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Image(asset: .coinsIcon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.appBrandPrimary)
                    .frame(width: 32, height: 32)
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
                    .opacity(particle.opacity)
                    .position(x: particle.x, y: particle.y)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .environment(\.layoutDirection, .leftToRight)
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        var newParticles: [CoinFlyParticle] = []
        
        let startBaseX = startPoint.x
        let startBaseY = startPoint.y
        
        for _ in 0..<coinCount {
            let startX = startBaseX + CGFloat.random(in: -30...30)
            let startY = startBaseY + CGFloat.random(in: -30...30)
            let scale = CGFloat.random(in: 0.6...1.1)
            let delay = 2.0 + Double.random(in: 0...0.5)
            let duration = Double.random(in: 1.2...1.8)
            let rotation = Double.random(in: 0...360)
            
            newParticles.append(CoinFlyParticle(
                x: startX,
                y: startY,
                scale: scale,
                opacity: 0.0,
                rotation: rotation,
                animationDelay: delay,
                animationDuration: duration
            ))
        }
        particles = newParticles
    }
    
    private func animateParticles() {
        let endBaseX = endPoint.x
        let endBaseY = endPoint.y
        
        for i in particles.indices {
            let delay = particles[i].animationDelay
            let duration = particles[i].animationDuration
            let endX = endBaseX + CGFloat.random(in: -10...10)
            let endY = endBaseY + CGFloat.random(in: -10...10)
            let endRotation = particles[i].rotation + Double.random(in: 180...540)
            
            // Fade in quickly
            withAnimation(.easeIn(duration: 0.2).delay(delay)) {
                particles[i].opacity = 1.0
            }
            
            // Fly to target
            withAnimation(.timingCurve(0.2, 0.8, 0.2, 1, duration: duration).delay(delay)) {
                particles[i].x = endX
                particles[i].y = endY
                particles[i].rotation = endRotation
                particles[i].scale = 0.5 // Shrink as they hit the badge
            }
            
            // Fade out right as they hit the badge
            withAnimation(.easeOut(duration: 0.2).delay(delay + duration - 0.2)) {
                particles[i].opacity = 0.0
            }
        }
    }
}
