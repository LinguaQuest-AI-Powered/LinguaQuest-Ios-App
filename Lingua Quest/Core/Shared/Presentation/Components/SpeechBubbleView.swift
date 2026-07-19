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
    var isAnimated: Bool = false
    var animationDelay: Double = 0.0
    
    @State private var displayedText: String = ""
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(.clear)
            .overlay(
                Text(isAnimated ? displayedText : text)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 20) // 12 + 8 (tailSize)
            .background(
                SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                    .fill(Color.appSurfaceCard)
                    .shadow(color: Color.appBorderBrown.opacity(0.2), radius: 6, x: 0, y: 3)
            )
            .overlay(
                SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                    .stroke(Color.appBorderBrown, lineWidth: 1.5)
            )
            .task(id: text) {
                guard isAnimated else {
                    displayedText = text
                    return
                }
                displayedText = ""
                if animationDelay > 0 {
                    try? await Task.sleep(nanoseconds: UInt64(animationDelay * 1_000_000_000))
                }
                let words = text.components(separatedBy: " ")
                for (index, word) in words.enumerated() {
                    if index == 0 {
                        displayedText = word
                    } else {
                        displayedText += " " + word
                    }
                    try? await Task.sleep(nanoseconds: 250_000_000) // 0.25 seconds per word
                }
            }
    }
}

#Preview {
    SpeechBubbleView(text: "TAP ME IF YOU\nWANT HELP")
        .padding()
        .background(Color.gray)
}
