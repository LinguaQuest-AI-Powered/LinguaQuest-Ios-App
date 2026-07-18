//
//  CustomButton.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 14/07/2026.
//

import SwiftUI

enum ButtonType {
    case primary
    case secendry
    // التعديل هنا: إضافة الـ shadowColor مع قيمة افتراضية عشان منكسرش أي كود قديم
    case custom(textColor: Color, buttonColor: Color, shadowColor: Color = Color.black.opacity(0.3))
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
    var disabledAction: (() -> Void)? = nil
    
    var backgroundColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                return Color.appBrandPrimary
            case .secendry:
                return Color.appBorderLight
            case .custom(_, let buttonColor, _):
                return buttonColor
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
            }
        } else {
            return Color.appBorderBrown
        }
    }
    
    var body: some View {
        Button {
            if status == .enable {
                action()
            } else {
                disabledAction?()
            }
        } label: {
            HStack(spacing: 8) {
                if let leading {
                    leading
                        .font(AppTextStyle.captionMedium.font)
                }
                
                Text(text)
                    .appTextStyle(.bodyLargeBold, color: foregroundColor)
                
                if let trailing {
                    trailing
                        .font(AppTextStyle.captionMedium.font)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .foregroundColor(foregroundColor)
        // MARK: - The 3D Magic
        .background(
            Capsule()
                .fill(backgroundColor)
                .shadow(color: shadowColor, radius: 0, x: 0, y: 4)
        )
        .padding(.bottom, 4)
        .disabled(status == .disable && disabledAction == nil)
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
            leading: Image(systemName: "star.fill")
        )
        
        CustomButton(
            type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
            text: "SAVE CHANGES (Custom 3D)",
            action: { print("Save tapped") }
        )
    }
    .padding(24)
    .background(Color.appBackgroundWarm)
}
