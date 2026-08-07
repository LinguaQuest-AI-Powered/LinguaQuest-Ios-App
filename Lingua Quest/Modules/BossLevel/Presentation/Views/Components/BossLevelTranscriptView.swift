

import SwiftUI

struct BossLevelTranscriptView: View {
    let messages: [RoleplayMessage]
    var onTapToTalk: (() -> Void)? = nil
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        messageBubble(message)
                            .id(message.id)
                    }
                }
            }
            .onChange(of: messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: messages.last?.text) { _, _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastId = messages.last?.id {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
    
    @ViewBuilder
    private func messageBubble(_ message: RoleplayMessage) -> some View {
        let isUser = message.sender == .user
        HStack {
            if isUser { Spacer(minLength: 50) }
            Text(message.text)
                .appTextStyle(.bodyMedium, color: isUser ? .appTextHeading : .appTextPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isUser ? Color.appAccentOrange : Color.appSurfaceCardMuted)
                .cornerRadius(16)
            if !isUser { Spacer(minLength: 50) }
        }
    }
}
