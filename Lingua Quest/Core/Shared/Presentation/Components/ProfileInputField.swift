//
//  ProfileInputField.swift
//  LinguaQuest
//

import SwiftUI

struct ProfileInputField: View {
    let title: String
    let placeholder: String
    let icon: Image.SystemIcon
    let isMultiline: Bool
    let isSecure: Bool
    @Binding var text: String

    @State private var isRevealed: Bool = false

    init(
        title: String,
        placeholder: String,
        icon: Image.SystemIcon,
        isMultiline: Bool = false,
        isSecure: Bool = false,
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self.isMultiline = isMultiline
        self.isSecure = isSecure
        self._text = text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .appTextStyle(.body, color: .appIconBrown)

            HStack(alignment: isMultiline ? .bottom : .center, spacing: 12) {
                Group {
                    if isSecure {
                        NoPasteTextField(
                            placeholder: placeholder,
                            text: $text,
                            isSecureTextEntry: !isRevealed,
                            fontStyle: .body,
                            textColor: .appTextHeading
                        )
                    } else if isMultiline {
                        TextField(
                            "",
                            text: $text,
                            prompt: Text(placeholder)
                                .foregroundColor(Color.appTextSecondary.opacity(0.5)),
                            axis: .vertical
                        )
                        .lineLimit(4, reservesSpace: true)
                    } else {
                        TextField(
                            "",
                            text: $text,
                            prompt: Text(placeholder)
                                .foregroundColor(Color.appTextSecondary.opacity(0.5))
                        )
                    }
                }
                // Apply standard styles only for SwiftUI native textfields, as NoPasteTextField handles it internally
                .appTextStyle(.body, color: .appTextHeading)
                .multilineTextAlignment(.leading)
                .autocapitalization(.none)
                .disableAutocorrection(true)

                // Trailing icon — toggle visibility for secure fields, static otherwise
                if isSecure {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Image(systemIcon: isRevealed ? .eye : .eyeSlash)
                            .foregroundColor(.appBorderBrown)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.plain)
                } else {
                    Image(systemIcon: icon)
                        .foregroundColor(.appBorderBrown)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, isMultiline ? 16 : 0)
            .frame(height: isMultiline ? nil : 56)
            .background(Color.appSurfaceNavBar)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appBorderBrown, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()

        VStack(spacing: 24) {
            ProfileInputField(
                title: "Display Name",
                placeholder: "Explorer Alex",
                icon: .person,
                text: .constant("")
            )

            ProfileInputField(
                title: "Password",
                placeholder: "old password",
                icon: .lockFill,
                isSecure: true,
                text: .constant("")
            )

            ProfileInputField(
                title: "Explorer's Tagline",
                placeholder: "Mapping the wild frontiers...",
                icon: .squareAndPencil,
                isMultiline: true,
                text: .constant("")
            )
        }
        .padding()
    }
}
