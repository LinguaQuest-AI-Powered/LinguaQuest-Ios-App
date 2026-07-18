//
//  CustomBottomSheet.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import SwiftUI

// MARK: - Sheet Detent

enum SheetDetent: CaseIterable {
    case medium
    case large

    func height(in screenHeight: CGFloat) -> CGFloat {
        switch self {
        case .medium: return screenHeight * 0.55
        case .large:  return screenHeight * 0.9
        }
    }
}

// MARK: - CustomBottomSheet

struct CustomBottomSheet<Content: View>: View {

    // MARK: - Layout Constants

    private let cornerRadius: CGFloat = 32
    private let handleWidth: CGFloat = 40
    private let handleHeight: CGFloat = 5
    private let glowSize: CGFloat = 300
    private let glowBlur: CGFloat = 40
    private let glowOffset: CGFloat = 100
    private let dismissThreshold: CGFloat = 150
    private let snapThreshold: CGFloat = 80

    // MARK: - Properties

    @Binding var isPresented: Bool
    let content: Content

    // MARK: - State

    @State private var currentDetent: SheetDetent = .medium
    @State private var dragOffset: CGFloat = 0
    @State private var appeared = false

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height + geometry.safeAreaInsets.bottom

            ZStack(alignment: .bottom) {
                // Dimmed overlay
                if appeared {
                    Color.black.opacity(overlayOpacity(screenHeight: screenHeight))
                        .ignoresSafeArea()
                        .onTapGesture {
                            dismissSheet()
                        }
                        .transition(.opacity)
                        .animation(.easeOut(duration: 0.2), value: dragOffset)
                }

                // Sheet content
                if appeared {
                    sheetContent(screenHeight: screenHeight)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                appeared = true
            }
        }
        .onChange(of: isPresented) { _, newValue in
            if !newValue {
                dismissSheet()
            }
        }
    }
}

// MARK: - Private Views

private extension CustomBottomSheet {

    func sheetContent(screenHeight: CGFloat) -> some View {
        let sheetHeight = currentDetent.height(in: screenHeight)

        return VStack(spacing: 0) {
            // Drag handle
            dragHandle
                .padding(.top, 12)
                .padding(.bottom, 8)

            // User content
            content
        }
        .frame(maxWidth: .infinity)
        .frame(height: sheetHeight - dragOffset, alignment: .top)
        .clipped()
        .background(sheetBackground)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: cornerRadius
            )
        )
        .overlay(sheetBorder)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -8)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .gesture(dragGesture(screenHeight: screenHeight))
    }

    var dragHandle: some View {
        Capsule()
            .fill(Color.appBorderBrown.opacity(0.5))
            .frame(width: handleWidth, height: handleHeight)
    }

    var sheetBackground: some View {
        ZStack {
            Color.appSurfaceCard

            decorativeBackground
        }
    }

    var sheetBorder: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: cornerRadius,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: cornerRadius
        )
        .stroke(Color.appBorderCool, lineWidth: 1.5)
    }

    var decorativeBackground: some View {
        ZStack {
            Circle()
                .fill(Color.appGlowTeal.opacity(0.15))
                .frame(width: glowSize, height: glowSize)
                .blur(radius: glowBlur)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing
                )
                .offset(x: glowOffset, y: -glowOffset)

            Circle()
                .fill(Color.appGlowGold.opacity(0.15))
                .frame(width: glowSize, height: glowSize)
                .blur(radius: glowBlur)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottomLeading
                )
                .offset(x: -glowOffset, y: glowOffset)
        }
    }
}

// MARK: - Gestures & Logic

private extension CustomBottomSheet {

    func overlayOpacity(screenHeight: CGFloat) -> Double {
        let currentHeight = currentDetent.height(in: screenHeight) - dragOffset
        let maxHeight = SheetDetent.large.height(in: screenHeight)
        let ratio = max(0, min(1, currentHeight / maxHeight))
        return 0.4 * ratio
    }

    func dragGesture(screenHeight: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.height
            }
            .onEnded { value in
                let translation = value.translation.height

                // Dragging DOWN
                if translation > 0 {
                    if currentDetent == .large && translation < dismissThreshold {
                        // Snap back to medium
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            currentDetent = .medium
                            dragOffset = 0
                        }
                    } else if translation > dismissThreshold {
                        // Dismiss
                        dismissSheet()
                    } else {
                        // Snap back
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = 0
                        }
                    }
                }
                // Dragging UP
                else if translation < 0 {
                    if currentDetent == .medium && abs(translation) > snapThreshold {
                        // Expand to large
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                            currentDetent = .large
                            dragOffset = 0
                        }
                    } else {
                        // Snap back
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = 0
                        }
                    }
                }
            }
    }

    func dismissSheet() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            appeared = false
            dragOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            isPresented = false
        }
    }
}

// MARK: - View Modifier

struct CustomBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: SheetContent

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> SheetContent) {
        self._isPresented = isPresented
        self.sheetContent = content()
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    CustomBottomSheet(isPresented: $isPresented) {
                        sheetContent
                    }
                }
            }
    }
}

extension View {
    func customBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(CustomBottomSheetModifier(isPresented: isPresented, content: content))
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackgroundWarm
            .ignoresSafeArea()

        CustomBottomSheet(isPresented: .constant(true)) {
            VStack(spacing: 16) {
                Text("Sample Content")
                    .appTextStyle(.headingMedium, color: .appTextPrimary)
                    .padding(.top, 16)

                ForEach(0..<5) { index in
                    HStack(spacing: 12) {
                        Text("🇺🇸")
                            .font(.system(size: 24))
                        Text("Language \(index + 1)")
                            .appTextStyle(.bodyLarge, color: .appTextPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                }
            }
            .padding(.bottom, 40)
        }
    }
}
