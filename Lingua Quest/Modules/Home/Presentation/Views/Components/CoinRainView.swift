//
//  CoinRainView.swift
//  Lingua Quest
//
//  Created by taqieallah on 13/08/2026.
//

import SwiftUI

struct CoinParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var opacity: Double
    var rotation: Double
    var animationDelay: Double
    var animationDuration: Double
}

struct CoinRainView: View {
    @State private var particles: [CoinParticle] = []
    
    // Configurable parameters
    let coinCount = 100
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    static var hasAnimatedThisSession: Bool = false
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Image(asset: .coinsIcon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.appBrandPrimary)
                    .frame(width: 18, height: 18)
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
                    .opacity(particle.opacity)
                    .position(x: particle.x, y: particle.y)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .onAppear {
            if !Self.hasAnimatedThisSession {
                createParticles()
                animateParticles()
                Self.hasAnimatedThisSession = true
            }
        }
    }
    
    private func createParticles() {
        var newParticles: [CoinParticle] = []
        for _ in 0..<coinCount {
            let startX = CGFloat.random(in: 20...(screenWidth - 20))
            let startY = CGFloat.random(in: -200...(-50))
            let scale = CGFloat.random(in: 0.7...1.2)
            let delay = Double.random(in: 0...0.6)
            let duration = Double.random(in: 1.2...1.8)
            let rotation = Double.random(in: 0...360)
            
            newParticles.append(CoinParticle(
                x: startX,
                y: startY,
                scale: scale,
                opacity: 1.0,
                rotation: rotation,
                animationDelay: delay,
                animationDuration: duration
            ))
        }
        particles = newParticles
    }
    
    private func animateParticles() {
        for i in particles.indices {
            let delay = particles[i].animationDelay
            let duration = particles[i].animationDuration
            let endY = screenHeight / 2 + CGFloat.random(in: -100...100)
            let endRotation = particles[i].rotation + Double.random(in: 180...720)
            
            withAnimation(.linear(duration: duration).delay(delay)) {
                particles[i].y = endY
                particles[i].rotation = endRotation
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(delay + duration - 0.4)) {
                particles[i].opacity = 0.0
            }
        }
    }
}
