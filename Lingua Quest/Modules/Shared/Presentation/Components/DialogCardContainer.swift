//
//  DialogCardContainer.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct DialogCardContainer<Content: View>: View {

    // MARK: - Layout Constants

    private var mascotSize: CGFloat { 192 }
    private var mascotOffset: CGFloat {
        mascotSize * 0.5
    }
    private var mascotTopSpacing: CGFloat { 120 }
    private var horizontalPadding: CGFloat { 20 }
    private var bottomPadding: CGFloat { 30 }
    private var cornerRadius: CGFloat { 48 }
    private var borderWidth: CGFloat { 2 }
    private var glowSize: CGFloat { 256 }
    private var glowBlur: CGFloat { 32 }
    private var glowOffset: CGFloat { 94 }

    // MARK: - Properties

    private let mascotImage: Image.Asset
    private let speechBubbleText: String?
    private let speechBubbleAnimated: Bool
    private let speechBubbleDelay: Double
    private let onMascotTap: (() -> Void)?
    private let content: Content

    init(
        mascotImage: Image.Asset = .dialogMascot,
        speechBubbleText: String? = nil,
        speechBubbleAnimated: Bool = true,
        speechBubbleDelay: Double = 0.5,
        onMascotTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.mascotImage = mascotImage
        self.speechBubbleText = speechBubbleText
        self.speechBubbleAnimated = speechBubbleAnimated
        self.speechBubbleDelay = speechBubbleDelay
        self.onMascotTap = onMascotTap
        self.content = content()
    }

    // MARK: - Body

    var body: some View {

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
            mascotView
        }
        .compositingGroup()
        .dialogCardShadow()
        .padding(.top, mascotOffset + 10)
    }
}

// MARK: - Private Views

private extension DialogCardContainer {
    var mascotView: some View {
        Button {
            onMascotTap?()
        } label: {
            Image(asset: mascotImage)
                .resizable()
                .scaledToFit()
                .frame(width: mascotSize, height: mascotSize)
        }
        .buttonStyle(.plain)
        .overlay(alignment: .top) {
            if let text = speechBubbleText {
                SpeechBubbleView(text: text, isAnimated: speechBubbleAnimated, animationDelay: speechBubbleDelay)
                    .offset(y: -40)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .offset(y: -mascotOffset)
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
                Color.appBorderCool,
                lineWidth: borderWidth
            )
    }

    var decorativeBackground: some View {
        ZStack {
            Circle()
                .fill(Color.appGlowTeal.opacity(0.2))
                .frame(width: glowSize,
                       height: glowSize)
                .blur(radius: glowBlur)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing
                )
                .offset(
                    x: glowOffset,
                    y: -glowOffset
                )

            Circle()
                .fill(Color.appGlowGold.opacity(0.2))
                .frame(width: glowSize,
                       height: glowSize)
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
