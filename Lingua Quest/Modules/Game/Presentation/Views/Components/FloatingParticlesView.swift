//
//  FloatingParticlesView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

/// Floating sparkle particles that drift upwards to give a magical atmosphere
struct FloatingParticlesView: View {
    let width: CGFloat
    let height: CGFloat
    let particleCount: Int
    
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let size: CGFloat
        let opacity: Double
        let duration: Double
        var targetY: CGFloat
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white)
                    .frame(width: particle.size, height: particle.size)
                    .opacity(particle.opacity)
                    .blur(radius: particle.size > 5 ? 1 : 0)
                    .position(x: particle.x, y: particle.y)
            }
        }
        .frame(width: width, height: height)
        .allowsHitTesting(false) // Don't block scroll gestures
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        particles = (0..<particleCount).map { _ in
            let startY = CGFloat.random(in: 0...height)
            return Particle(
                x: CGFloat.random(in: 0...width),
                y: startY,
                size: CGFloat.random(in: 3...7),
                opacity: Double.random(in: 0.15...0.45),
                duration: Double.random(in: 4...9),
                targetY: startY - CGFloat.random(in: 80...200)
            )
        }
        
        // Animate each particle upward with a forever loop
        for i in particles.indices {
            withAnimation(
                .easeInOut(duration: particles[i].duration)
                .repeatForever(autoreverses: true)
                .delay(Double.random(in: 0...3))
            ) {
                particles[i].y = particles[i].targetY
            }
        }
    }
}
