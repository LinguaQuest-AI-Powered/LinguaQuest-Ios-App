//
//  WordWidgetLiveActivity.swift
//  Lingua Quest
//
//  Created by siam on 24/07/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WordWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WordWidgetAttributes.self) { context in
            let isArabic = context.state.isAppArabic
            
            VStack(alignment: .leading, spacing: 12) {
                // App Logo & Name Header
                HStack {
                    HStack(spacing: 8) {
                        Image(asset: .bird)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(4)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                        
                        Text(context.state.localizedAppName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.appTextPrimary)
                    }
                    
                    Spacer()
                    
                    Text(context.state.localizedTargetLanguage.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                        .foregroundColor(Color.appTextPrimary)
                }
                
                // Word and Meaning
                let isTargetArabic = context.state.targetLanguage.lowercased().contains("arabic") || context.state.targetLanguage.lowercased().contains("ar")
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(context.state.word)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.appTextPrimary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(context.state.meaning)
                        .font(.subheadline)
                        .foregroundColor(Color.appTextSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .minimumScaleFactor(0.85)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .environment(\.layoutDirection, isTargetArabic ? .rightToLeft : .leftToRight)
                
                HStack {
                    Text(context.state.localizedDifficulty.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficultyColor(context.state.difficulty).opacity(0.8))
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                        
                    Spacer()
                    
                    Image(systemIcon: .handTapFill)
                        .font(.caption)
                        .foregroundColor(Color.appTextSecondary)
                    Text(context.state.localizedTapToOpen)
                        .font(.caption2)
                        .foregroundColor(Color.appTextSecondary)
                }
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
            .padding(20)
            .widgetURL(URL(string: "linguaquest://word?id=\(context.state.wordId)"))
            .background(
                ZStack {
                    Color.appSurfaceCard
                    
                    Circle()
                        .fill(Color.appGlowTeal.opacity(0.15))
                        .frame(width: 200, height: 200)
                        .blur(radius: 24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .offset(x: 70, y: -70)

                    Circle()
                        .fill(Color.appGlowGold.opacity(0.15))
                        .frame(width: 200, height: 200)
                        .blur(radius: 24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .offset(x: -70, y: 70)
                }
            )
            // Use clear tint so the custom background fully takes over
            .activityBackgroundTint(Color.clear)
            .activitySystemActionForegroundColor(.white)
            .environment(\.colorScheme, context.state.isDarkMode ? .dark : .light)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.localizedTargetLanguage.prefix(2).uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.teal)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.localizedDifficulty.prefix(1).uppercased())
                        .font(.headline)
                        .foregroundColor(difficultyColor(context.state.difficulty))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .center, spacing: 4) {
                        Text(context.state.word)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(context.state.meaning)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            } compactLeading: {
                Image(systemIcon: .characterBookClosedFill)
                    .foregroundColor(.teal)
            } compactTrailing: {
                Text(context.state.word.prefix(3))
                    .font(.caption)
            } minimal: {
                Image(systemIcon: .characterBookClosedFill)
                    .foregroundColor(.teal)
            }
            .widgetURL(URL(string: "linguaquest://word?id=\(context.state.wordId)"))
            .keylineTint(Color.teal)
        }
    }
    
    private func difficultyColor(_ level: String) -> Color {
        switch level.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .teal
        }
    }
}

extension WordWidgetAttributes {
    fileprivate static var preview: WordWidgetAttributes {
        WordWidgetAttributes()
    }
}

extension WordWidgetAttributes.ContentState {
    fileprivate static var example: WordWidgetAttributes.ContentState {
        WordWidgetAttributes.ContentState(
            wordId: UUID().uuidString,
            word: "Schmetterling",
            meaning: "Butterfly",
            difficulty: "Medium",
            targetLanguage: "German",
            localizedAppName: "Lingua Quest",
            localizedTapToOpen: "Tap to open & listen",
            localizedDifficulty: "Medium",
            localizedTargetLanguage: "German",
            isDarkMode: true,
            isAppArabic: true
        )
     }
}

#Preview("Live Activity", as: .content, using: WordWidgetAttributes.preview) {
   WordWidgetLiveActivity()
} contentStates: {
    WordWidgetAttributes.ContentState.example
}
