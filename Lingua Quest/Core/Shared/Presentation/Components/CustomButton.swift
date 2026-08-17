//
//  CustomButton.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 14/07/2026.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

enum ButtonType {
    case primary
    case secendry
    case custom(textColor: Color, buttonColor: Color, shadowColor: Color = Color.black.opacity(0.3))
    case outline(textColor: Color, borderColor: Color)
}

enum ButtonStatus {
    case enable
    case disable
}

struct CustomButton: View {
    
    // CustomButton(type: .primary, text: "tap me", action: sayHello, status: .enable)
        
    // Required
    let type: ButtonType
    let text: String
    let action: () -> Void
    var status: ButtonStatus = .enable
    
    // Optional
    var leading: Image?
    var trailing: Image?
    var isLoading: Bool = false
    var disabledAction: (() -> Void)? = nil
    var textStyle: AppTextStyle = .bodyLargeBold
    
    @Environment(\.soundPlayer) private var soundPlayer
    
    var backgroundColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                return Color.appBrandPrimary
            case .secendry:
                return Color.appBorderLight
            case .custom(_, let buttonColor, _):
                return buttonColor
            case .outline:
                return Color.clear
            }
        } else {
            return Color.appSurfaceCardMuted
        }
    }
    
    var foregroundColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                return Color.appTextOnPrimary
            case .secendry:
                return Color.appTextSecondary
            case .custom(let textColor, _, _):
                return textColor
            case .outline(let textColor, _):
                return textColor
            }
        } else {
            return Color.appTextDarkGray
        }
    }
    
    // MARK: - Updated: Dynamic 3D Shadow Color
    var shadowColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                return Color.appBrandBrownDark
            case .secendry:
                return Color.appBorderBrown
            case .custom(_, _, let customShadow):
                return customShadow
            case .outline(_, let borderColor):
                return borderColor
            }
        } else {
            return Color.appBorderBrown
        }
    }
    
    var body: some View {
        Button {
            if status == .enable && !isLoading {
                if case .primary = type {
                    soundPlayer.play(sound: .pop)
                }
                action()
            } else {
                disabledAction?()
            }
        } label: {
            HStack(spacing: 8) {
                if isLoading {
                    CustomLoadingIndicator(color: foregroundColor)
                } else {
                    if let leading {
                        leading
                            .font(AppTextStyle.captionMedium.font)
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                    
                    Text(text)
                        .appTextStyle(textStyle, color: foregroundColor)
                    
                    if let trailing {
                        trailing
                            .font(AppTextStyle.captionMedium.font)
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .contentShape(Rectangle())
            .foregroundColor(foregroundColor)
            // MARK: - The 3D Magic
            .background(
                Group {
                    if case .outline(_, let borderColor) = type {
                        Capsule()
                            .stroke(borderColor, lineWidth: 2)
                            .shadow(color: borderColor, radius: 0, x: 0, y: 2)
                    } else {
                        Capsule()
                            .fill(backgroundColor)
                            .shadow(color: shadowColor, radius: 0, x: 0, y: 4)
                    }
                }
            )
            .padding(.bottom, 4)
        }
        .buttonStyle(ScaledButtonStyle())
        .disabled((status == .disable || isLoading) && disabledAction == nil)
    }
}

struct CustomLoadingIndicator: View {
    let color: Color
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1.2 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(0.2 * Double(index)),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct AppButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.soundPlayer) private var soundPlayer
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shimmerOffset: CGFloat = -200
    
    let text: String
    let icon: Image.SystemIcon
    var height: CGFloat = 56
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            soundPlayer.play(sound: .pop)
            action()
        }) {
            HStack(spacing: 8) {
                Image(systemIcon: icon)
                Text(text)
                    .font(AppTextStyle.bodyLargeMedium.font)
             }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                ZStack {
                    LinearGradient(
                        colors: [.appBrandPrimary, .appAccentOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    if !reduceMotion {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .white.opacity(0.2),
                                        .clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .mask(Capsule())
                            .animation(
                                .linear(duration: 2.0)
                                .repeatForever(autoreverses: false)
                                .delay(1.0),
                                value: shimmerOffset
                            )
                    }
                }
            )
            .clipShape(Capsule())
            .shadow(color: Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.24 : 0.18), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(ScaledButtonStyle())
        .onAppear {
            guard !reduceMotion else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                shimmerOffset = 400
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        CustomButton(
            type: .primary,
            text: "Primary Enabled",
            action: { print("Primary tapped") }
        )
        
        CustomButton(
            type: .primary,
            text: "Primary Disabled",
            action: { print("Won't fire") },
            status: .disable
        )
        
        CustomButton(
            type: .secendry,
            text: "Secondary Enabled",
            action: { print("Secondary tapped") },
            status: .enable
        )
        
        CustomButton(
            type: .custom(textColor: .white, buttonColor: .appAccentTeal),
            text: "Custom Default Shadow",
            action: { print("Custom tapped") },
            leading: Image(systemIcon: .starFill)
        )
        
        CustomButton(
            type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
            text: "SAVE CHANGES (Custom 3D)",
            action: { print("Save tapped") }
        )
        
        CustomButton(
            type: .primary,
            text: "Loading State",
            action: { print("Won't fire") },
            isLoading: true
        )
    }
    .padding(24)
    .background(Color.appBackgroundWarm)
}
