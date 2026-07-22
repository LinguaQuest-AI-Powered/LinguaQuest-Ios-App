//
//  SentenceBreakdownView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

public struct WordResult: Equatable {
    public let word: String
    public let isCorrect: Bool
    
    public init(word: String, isCorrect: Bool) {
        self.word = word
        self.isCorrect = isCorrect
    }
}

struct SentenceBreakdownView: View {
    let words: [WordResult]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(words.enumerated()), id: \.offset) { index, wordResult in
                    HStack(spacing: 4) {
                        Text(wordResult.word)
                            .font(AppTextStyle.bodyBold.font)
                        
                        Image(systemIcon: wordResult.isCorrect ? .checkmarkCircleFill : .infoCircleFill)
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(wordResult.isCorrect ? Color.green.opacity(0.15) : Color.appBrandBrown.opacity(0.15))
                    .foregroundColor(wordResult.isCorrect ? .green : .appBrandBrown)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(wordResult.isCorrect ? Color.green : Color.appBrandBrown, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
    }
}
