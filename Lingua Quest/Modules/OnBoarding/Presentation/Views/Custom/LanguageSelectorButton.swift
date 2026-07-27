//
//  LanguageSelectorButton.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LanguageSelectorButton: View {
    let title: String
    let placeholder: String
    let selectedName: String?
    let selectedFlag: String?
    let action: () -> Void

    private var isSelected: Bool {
        selectedName != nil
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .appTextStyle(.micro, color: .appTextSecondary.opacity(0.8))

                HStack(spacing: 12) {
                    if let name = selectedName, let flag = selectedFlag {
                        Text(flag)
                            .font(.system(size: 20))
                            .frame(width: 20, height: 20)

                        Text(name)
                            .appTextStyle(.bodyLargeMedium, color: .appTextPrimary)
                    } else {
                        Text(placeholder)
                            .appTextStyle(.bodyLargeMedium, color: .appTextSecondary.opacity(0.5))
                    }

                    Spacer()

                    Image(systemIcon: .chevronDown)
                        .appTextStyle(.captionMedium, color: isSelected ? .appBrandPrimary : .appTextSecondary.opacity(0.6))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.appSurfaceCard)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.appBrandPrimary : Color.appBorderLight, lineWidth: isSelected ? 2.0 : 1.5)
            }
            .cornerRadius(18)
            .shadow(color: isSelected ? Color.appBrandPrimary.opacity(0.08) : Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 16) {
        LanguageSelectorButton(
            title: "I SPEAK...",
            placeholder: "Select language",
            selectedName: nil,
            selectedFlag: nil,
            action: {}
        )
        
        LanguageSelectorButton(
            title: "I WANT TO LEARN...",
            placeholder: "Select language",
            selectedName: "English",
            selectedFlag: "🇬🇧",
            action: {}
        )
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
