//
//  CustomSecureField.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct CustomSecureField: View {
    var icon: Image.SystemIcon
    var placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemIcon: icon)
                .foregroundColor(.appIconBrown)
                .frame(width: 20)
            
                NoPasteTextField(
                    placeholder: placeholder,
                    text: $text,
                    isSecureTextEntry: !isVisible,
                    fontStyle: .body,
                    textColor: .appTextSecondary
                )
            // Properties applied natively in NoPasteTextField
            
            Button(action: {
                isVisible.toggle()
            }) {
                Image(systemIcon: isVisible ? .eyeSlashFill : .eyeFill)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 16)
        .frame(height: 52)
        .background(Color.appBackgroundPrimary)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.appBorderBrown, lineWidth: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        
        VStack(spacing: 20) {
            CustomSecureField(
                icon: .lockFill,
                placeholder: L10n.Auth.passwordPlaceholder,
                text: .constant(""),
                isVisible: .constant(false)
            )
            
            CustomSecureField(
                icon: .lockFill,
                placeholder: L10n.Auth.passwordPlaceholder,
                text: .constant("MySecretPass123!"),
                isVisible: .constant(true)
            )
        }
        .padding()
    }
}

// MARK: - NoPasteTextField implementation
class NoPasteUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

struct NoPasteTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var isSecureTextEntry: Bool = false
    var fontStyle: AppTextStyle = .body
    var textColor: Color = .appTextHeading
    
    @Environment(\.layoutDirection) var layoutDirection

    func makeUIView(context: Context) -> NoPasteUITextField {
        let textField = NoPasteUITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.isSecureTextEntry = isSecureTextEntry
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textAlignment = layoutDirection == .rightToLeft ? .right : .left
        textField.semanticContentAttribute = layoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
        
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(Color.appTextSecondary).withAlphaComponent(0.5)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        textField.font = uiFont(for: fontStyle)
        textField.textColor = UIColor(textColor)
        
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }

    func updateUIView(_ uiView: NoPasteUITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.isSecureTextEntry = isSecureTextEntry
        uiView.textColor = UIColor(textColor)
        uiView.textAlignment = layoutDirection == .rightToLeft ? .right : .left
        uiView.semanticContentAttribute = layoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NoPasteTextField

        init(_ parent: NoPasteTextField) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text = textField.text ?? ""
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.text = textField.text ?? ""
        }
    }
    
    private func uiFont(for style: AppTextStyle) -> UIFont {
        switch style {
        case .displayLarge:      return .systemFont(ofSize: 34, weight: .bold)
        case .displayMedium:     return .systemFont(ofSize: 30, weight: .bold)
        case .displaySmall:      return .systemFont(ofSize: 28, weight: .bold)
        case .headingLarge:      return .systemFont(ofSize: 24, weight: .bold)
        case .headingMedium:     return .systemFont(ofSize: 22, weight: .semibold)
        case .headingMediumBold: return .systemFont(ofSize: 22, weight: .bold)
        case .bodyLargeBold:     return .systemFont(ofSize: 18, weight: .bold)
        case .bodyLargeMedium:   return .systemFont(ofSize: 18, weight: .medium)
        case .bodyLarge:         return .systemFont(ofSize: 18, weight: .regular)
        case .bodyBold:          return .systemFont(ofSize: 16, weight: .bold)
        case .bodySemibold:      return .systemFont(ofSize: 16, weight: .semibold)
        case .bodyMedium:        return .systemFont(ofSize: 16, weight: .medium)
        case .body:              return .systemFont(ofSize: 16, weight: .regular)
        case .captionBold:       return .systemFont(ofSize: 14, weight: .bold)
        case .captionMedium:     return .systemFont(ofSize: 14, weight: .medium)
        case .caption:           return .systemFont(ofSize: 14, weight: .regular)
        case .microHeavy:        return .systemFont(ofSize: 12, weight: .heavy)
        case .microBold:         return .systemFont(ofSize: 12, weight: .bold)
        case .microSemibold:     return .systemFont(ofSize: 12, weight: .semibold)
        case .micro:             return .systemFont(ofSize: 10, weight: .bold)
        }
    }
}
