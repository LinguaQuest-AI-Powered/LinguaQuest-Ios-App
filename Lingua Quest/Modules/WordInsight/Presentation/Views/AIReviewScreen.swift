//
//  AIReviewScreen.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

// MARK: - Mock Models (Replace with your actual domain models)
struct ReviewWordEntity {
    let id: Int
    let sourceWord: String
    let translatedWord: String
    let sourceLanguage: String
    let targetLanguage: String
    let category: String
    let imageURL: String
}

struct AIReviewResponseModel {
    let exampleSentence: String
    let sentenceTranslation: String
    let memoryTip: String
    let funFact: String
}

// MARK: - Main Screen
struct AIReviewScreen: View {
    // MARK: - Properties
    let word: ReviewWordEntity
    let aiResponse: AIReviewResponseModel
    var onBackTapped: () -> Void
    
    // State للتحكم في الأنيميشن والصوت
    @State private var speakingSectionId: String? = nil
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Bar
                reviewTopBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 2. Word Header Card (Image + Details)
                        wordHeaderCard
                            .padding(.top, 16)
                        
                        // 3. AI Generated Sections
                        VStack(spacing: 12) {
                            
                            ReviewSectionCard(
                                emoji: "📝",
                                title: "EXAMPLE SENTENCE",
                                content: aiResponse.exampleSentence,
                                accentColor: .appAccentOrange,
                                isSpeaking: speakingSectionId == "sentence",
                                onSpeakTapped: { toggleSpeaking(for: "sentence") }
                            )
                            
                            ReviewSectionCard(
                                emoji: "🔤",
                                title: "TRANSLATION",
                                content: aiResponse.sentenceTranslation,
                                accentColor: .appBrandPrimary,
                                isItalic: true,
                                isSpeaking: speakingSectionId == "translation",
                                onSpeakTapped: { toggleSpeaking(for: "translation") }
                            )
                            
                            ReviewSectionCard(
                                emoji: "🧠",
                                title: "MEMORY TIP",
                                content: aiResponse.memoryTip,
                                accentColor: .appBrandBrown,
                                isSpeaking: speakingSectionId == "memory",
                                onSpeakTapped: { toggleSpeaking(for: "memory") }
                            )
                            
                            ReviewSectionCard(
                                emoji: "💡",
                                title: "FUN FACT",
                                content: aiResponse.funFact,
                                accentColor: .appSemanticSuccess,
                                isSpeaking: speakingSectionId == "funfact",
                                onSpeakTapped: { toggleSpeaking(for: "funfact") }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var reviewTopBar: some View {
        HStack {
            Button(action: onBackTapped) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.appBrandBrownDark)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurfaceCard)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            }
            
            Spacer()
            
            Text("AI Review")
                .appTextStyle(.headingLarge, color: .appBrandBrownDark)
            
            Spacer()
            
            Color.clear.frame(width: 44, height: 44) // Balance
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
    }
    
    private var wordHeaderCard: some View {
        ZStack {
            // Background Image (Placeholder for AsyncImage)
            Rectangle()
                .fill(Color.appBrandPrimary.opacity(0.3))
                .overlay(
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.5))
                )
            
            // Dark Gradient for text readability
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Content
            VStack {
                HStack {
                    Spacer()
                    // Category Badge
                    Text(word.category.uppercased())
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .tracking(1)
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.appBrandBrown.opacity(0.9))
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.sourceWord)
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(word.translatedWord)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    
                    Spacer()
                    
                    // Language Direction Badge
                    Text("\(word.sourceLanguage) ➝ \(word.targetLanguage)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding(16)
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
    }
    
    // MARK: - Actions
    private func toggleSpeaking(for section: String) {
        withAnimation(.spring()) {
            if speakingSectionId == section {
                speakingSectionId = nil
                // Stop TTS logic here
            } else {
                speakingSectionId = section
                // Start TTS logic here
            }
        }
    }
}

// MARK: - Review Section Card Component
struct ReviewSectionCard: View {
    let emoji: String
    let title: String
    let content: String
    let accentColor: Color
    var isItalic: Bool = false
    let isSpeaking: Bool
    let onSpeakTapped: () -> Void
    
    // للتحكم في تأثير النبض (Pulse)
    @State private var isPulsing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(emoji)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .tracking(1)
                    .foregroundColor(accentColor)
                
                Spacer()
                
                // Speak Button with Pulse Animation
                Button(action: onSpeakTapped) {
                    Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isSpeaking ? .white : accentColor)
                        .frame(width: 36, height: 36)
                        .background(isSpeaking ? accentColor : accentColor.opacity(0.15))
                        .clipShape(Circle())
                        .scaleEffect(isSpeaking && isPulsing ? 1.15 : 1.0)
                        .animation(
                            isSpeaking ? Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .default,
                            value: isPulsing
                        )
                }
            }
            
            // Divider Line
            RoundedRectangle(cornerRadius: 2)
                .fill(accentColor.opacity(0.3))
                .frame(width: 32, height: 3)
            
            Text(content)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .italic(isItalic)
                .foregroundColor(.appTextPrimary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.appSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(accentColor.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
        .onChange(of: isSpeaking) { newValue in
            if newValue {
                isPulsing = true
            } else {
                isPulsing = false
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let mockWord = ReviewWordEntity(
        id: 1,
        sourceWord: "Apple",
        translatedWord: "تفاحة",
        sourceLanguage: "ENG",
        targetLanguage: "AR",
        category: "Food",
        imageURL: ""
    )
    
    let mockResponse = AIReviewResponseModel(
        exampleSentence: "She ate a red apple for breakfast.",
        sentenceTranslation: "أكلت تفاحة حمراء على الفطور.",
        memoryTip: "Think of the apple emoji 🍎 – it starts the ABC, just like learning starts with basics.",
        funFact: "There are more than 7,500 known cultivars of apples grown around the world."
    )
    
    return AIReviewScreen(
        word: mockWord,
        aiResponse: mockResponse,
        onBackTapped: {}
    )
}
