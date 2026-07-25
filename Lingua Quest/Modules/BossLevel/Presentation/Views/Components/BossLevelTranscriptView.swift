//
//  BossLevelTranscriptView.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import SwiftUI

struct BossLevelTranscriptView: View {
    let messages: [RoleplayMessage]
    var onTapToTalk: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.bubble.fill")
                    .foregroundColor(Color.appBrandPrimary)
                Text(L10n.BossLevel.liveTranscript)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color.appTextHeading)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        if messages.isEmpty {
                            Button(action: { onTapToTalk?() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "mic.fill")
                                        .foregroundColor(Color.appBrandPrimary)
                                    Text(L10n.BossLevel.tapToTalk)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color.appBrandPrimary)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .background(Color.appBrandPrimary.opacity(0.1))
                                .cornerRadius(24)
                            }
                            .buttonStyle(.plain)
                            .padding(.vertical, 20)
                        } else {
                            ForEach(messages) { message in
                                messageBubble(message)
                                    .id(message.id)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastId = messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .background(Color.appSurfaceCard)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.appBorderCool, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func messageBubble(_ message: RoleplayMessage) -> some View {
        let isUser = message.sender == .user
        HStack {
            if isUser { Spacer(minLength: 40) }
            Text(message.text)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(isUser ? Color.appTextOnPrimary : Color.appTextPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isUser ? Color.appBrandPrimary : Color.appSurfaceCardMuted)
                .cornerRadius(16)
            if !isUser { Spacer(minLength: 40) }
        }
    }
}
