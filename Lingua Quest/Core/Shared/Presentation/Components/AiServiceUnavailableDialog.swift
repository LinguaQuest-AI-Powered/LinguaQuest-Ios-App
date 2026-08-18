//
//  AiServiceUnavailableDialog.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

struct AiServiceUnavailableDialog: View {
    @Binding var isPresented: Bool
    var onOkTapped: (() -> Void)? = nil
    
    @Environment(\.colorScheme) private var colorScheme
    
    var subtitle: String {
        L10n.Common.aiServiceUnavailableSubtitle
    }
    
    var body: some View {
        DialogCardContainer {
            VStack(spacing: 24) {
                // Header Icon
                ZStack {
                    Circle()
                        .fill(Color.appAccentOrange.opacity(0.15))
                        .frame(width: 80, height: 80)
                    
                    Image(systemIcon: .exclamationmarkTriangleFill)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.appAccentOrange)
                }
                .padding(.top, 10)
                
                // Titles
                VStack(spacing: 8) {
                    Text(L10n.Common.error)
                        .font(AppTextStyle.headingMediumBold.font)
                        .foregroundColor(.appTextHeading)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(AppTextStyle.bodyLargeMedium.font)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                
                // Button
                AppButton(
                    text: L10n.Common.ok,
                    icon: .checkmark,
                    action: {
                        isPresented = false
                        onOkTapped?()
                    }
                )
                .padding(.top, 10)
            }
        }
    }
}

// MARK: - ViewModifier & Extension

struct AiUnavailableDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    var onOkTapped: (() -> Void)? = nil
    
    func body(content: Content) -> some View {
        content
            .appDialog(isPresented: $isPresented) {
                AiServiceUnavailableDialog(isPresented: $isPresented, onOkTapped: onOkTapped)
            }
    }
}

extension View {
    func aiUnavailableDialog(isPresented: Binding<Bool>, onOkTapped: (() -> Void)? = nil) -> some View {
        self.modifier(AiUnavailableDialogModifier(isPresented: isPresented, onOkTapped: onOkTapped))
    }
}
