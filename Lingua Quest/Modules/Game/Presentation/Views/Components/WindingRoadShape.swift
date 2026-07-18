//
//  WindingRoadShape.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

/// Helper to ensure the Shape and the Nodes use the exact same mathematical curve
struct RoadMath {
    /// Calculates the X position of the road for a given Y position.
    /// - Parameters:
    ///   - y: The vertical position
    ///   - width: The total width of the container
    /// - Returns: The calculated X position
    static func xPosition(for y: CGFloat, in width: CGFloat) -> CGFloat {
        let amplitude = width * 0.30 // How far left/right the road swings
        let frequency: CGFloat = 100 // How tight the curves are (higher = looser)
        return (width / 2) + sin(y / frequency) * amplitude
    }
}

struct WindingRoadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard rect.width > 0 && rect.height > 0 else { return path }
        
        // Start from bottom
        let startX = RoadMath.xPosition(for: rect.maxY, in: rect.width)
        path.move(to: CGPoint(x: startX, y: rect.maxY))
        
        // Draw up to top
        for y in stride(from: rect.maxY, through: 0, by: -5) {
            let x = RoadMath.xPosition(for: y, in: rect.width)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}
