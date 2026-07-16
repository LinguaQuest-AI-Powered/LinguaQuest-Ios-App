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
    case custom(textColor: Color, buttonColor: Color)
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
    
    var backgroundColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                return Color.appPrimary
            case .secendry:
                return Color.appSecondary
            case .custom(_, let buttonColor):
                return buttonColor
            }
        } else {
            return .gray
        }
    }
    
    var foregroundColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                return Color.primaryButtonText
            case .secendry:
                return Color.secondaryButtonText
            case .custom(let textColor, _):
                return textColor
            }
        } else {
            return .white
        }
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if let leading {
                    leading
                        .font(AppTextStyle.captionMedium.font)
                }
                
                Text(text)
                    .font(AppTextStyle.buttonMedium.font)
                
                if let trailing {
                    trailing
                        .font(AppTextStyle.captionMedium.font)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 32)
            .contentShape(Rectangle())
        }
        .padding()
        .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .cornerRadius(100)
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
        .disabled(status == .disable)
    }
}

#Preview {
    VStack(spacing: 16) {
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
            text: "Secondry Enabled",
            action: { print("Won't fire") },
            status: .enable
        )
        
        CustomButton(
            type: .custom(textColor: .white, buttonColor: .blue),
            text: "Custom Enabled",
            action: { print("Custom tapped") },
            leading: Image(systemName: "star.fill")
        )
        
        CustomButton(
            type: .custom(textColor: .black, buttonColor: .yellow),
            text: "Custom with Trailing",
            action: { print("Trailing tapped") },
            trailing: Image(systemName: "arrow.right")
        )
    }
    .padding()
}

