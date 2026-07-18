//
//  SpeechBubbleView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct SpeechBubbleShape: Shape {
    let cornerRadius: CGFloat
    let tailSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bubbleRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height - tailSize)
        
        path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // Add the tail
        let tailX = rect.width * 0.3 // Tail position
        path.move(to: CGPoint(x: tailX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: tailX - tailSize, y: rect.maxY))
        path.addLine(to: CGPoint(x: tailX + tailSize, y: bubbleRect.maxY))
        
        return path
    }
}

struct SpeechBubbleView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(Color.appTextBrown)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                    .fill(Color.appCardBackground)
                    .shadow(color: Color.appBorderBrown.opacity(0.2), radius: 6, x: 0, y: 3)
            )
            .overlay(
                SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                    .stroke(Color.appBorderBrown, lineWidth: 1.5)
            )
            .padding(.bottom, 8) // To account for the tail size
    }
}

#Preview {
    SpeechBubbleView(text: "TAP ME IF YOU\nWANT HELP")
        .padding()
        .background(Color.gray)
}
