//
//  DialogCardContainer.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct DialogCardContainer<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Layout Constants

    private var mascotWidth: CGFloat { customMascotSize?.width ?? 192 }
    private var mascotHeight: CGFloat { customMascotSize?.height ?? 192 }
    
    private var mascotOffset: CGFloat {
        mascotHeight * 0.5
    }
    private var mascotTopSpacing: CGFloat { showMascot ? (mascotOffset - 10) : 32 }
    private var horizontalPadding: CGFloat { 20 }
    private var bottomPadding: CGFloat { 30 }
    private var cornerRadius: CGFloat { 48 }
    private var borderWidth: CGFloat { 2 }
    private var glowSize: CGFloat { 256 }
    private var glowBlur: CGFloat { 32 }
    private var glowOffset: CGFloat { 94 }

    // MARK: - Properties

    private let showMascot: Bool
    private let mascotImage: Image.Asset
    private let customMascotSize: CGSize?
    private let speechBubbleText: String?
    private let customSpeechBubble: AnyView?
    private let speechBubbleAnimated: Bool
    private let speechBubbleDelay: Double
    private let onMascotTap: (() -> Void)?
    private let content: Content

    init(
        showMascot: Bool = true,
        mascotImage: Image.Asset = .bird,
        customMascotSize: CGSize? = nil,
        speechBubbleText: String? = nil,
        customSpeechBubble: AnyView? = nil,
        speechBubbleAnimated: Bool = true,
        speechBubbleDelay: Double = 0.5,
        onMascotTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.showMascot = showMascot
        self.mascotImage = mascotImage
        self.customMascotSize = customMascotSize
        self.speechBubbleText = speechBubbleText
        self.customSpeechBubble = customSpeechBubble
        self.speechBubbleAnimated = speechBubbleAnimated
        self.speechBubbleDelay = speechBubbleDelay
        self.onMascotTap = onMascotTap
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            if let customBubble = customSpeechBubble {
                customBubble
            }

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: mascotTopSpacing)

                content
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, bottomPadding)
            .frame(maxWidth: .infinity)
            .background(cardBackground)
            .overlay(cardBorder)
            .overlay(alignment: .top) {
                if showMascot {
                    mascotView
                }
            }
            .dialogCardShadow()
            .padding(.top, showMascot ? (mascotOffset - 25) : 0)
        }
    }
}

// MARK: - Private Views

private extension DialogCardContainer {
    var mascotView: some View {
        Group {
            if let onMascotTap {
                Button {
                    onMascotTap()
                } label: {
                    mascotImageContent
                }
                .buttonStyle(.plain)
            } else {
                mascotImageContent
            }
        }
        .overlay(alignment: .top) {
            if customSpeechBubble == nil, let text = speechBubbleText {
                SpeechBubbleView(text: text, isAnimated: speechBubbleAnimated, animationDelay: speechBubbleDelay)
                    .transition(.scale.combined(with: .opacity))
                    .offset(y: -50)
            }
        }
        .offset(y: -mascotOffset)
    }

    var mascotImageContent: some View {
        Image(asset: mascotImage)
            .resizable()
            .scaledToFit()
            .frame(width: mascotWidth, height: mascotHeight)
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.appSurfaceCard)
            .overlay {
                decorativeBackground
            }
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius)
            )
    }

    var cardBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                Color.appBorderCool.opacity(colorScheme == .dark ? 0.4 : 1.0),
                lineWidth: borderWidth
            )
    }

    var decorativeBackground: some View {
        ZStack {
            Circle()
                .fill(Color.appGlowTeal.opacity(colorScheme == .dark ? 0.12 : 0.2))
                .frame(width: glowSize, height: glowSize)
                .padding(glowBlur * 2)
                .blur(radius: glowBlur)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: glowOffset, y: -glowOffset)

            Circle()
                .fill(Color.appGlowGold.opacity(colorScheme == .dark ? 0.12 : 0.2))
                .frame(width: glowSize, height: glowSize)
                .padding(glowBlur * 2)
                .blur(radius: glowBlur)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottomLeading
                )
                .offset(
                    x: -glowOffset,
                    y: glowOffset
                )
        }
    }
}

// MARK: - Shadow

private extension View {

    func dialogCardShadow() -> some View {

        self
            .shadow(
                color: .black.opacity(0.10),
                radius: 10,
                x: 0,
                y: 10
            )
            .shadow(
                color: .black.opacity(0.08),
                radius: 6,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Preview

#Preview("Dialog Card Container") {
    ZStack {
        Color.appBackgroundPrimary
            .ignoresSafeArea()

        DialogCardContainer(mascotImage: .bird)  {
            
            VStack(spacing: 20) {

                Text(L10n.Components.appName)
                    .appTextStyle(.displayLarge, color: .appTextPrimary)

                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }

        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Dialog Text Modifiers

public extension View {
    /// Standardized title style for texts inside DialogCardContainer
    func dialogTitleStyle() -> some View {
        self.appTextStyle(.displayLarge, color: .appBrandBrown)
    }

    /// Standardized subtitle/message style for texts inside DialogCardContainer
    func dialogSubtitleStyle() -> some View {
        self.appTextStyle(.bodyMedium, color: .appTextSecondary)
    }
}
