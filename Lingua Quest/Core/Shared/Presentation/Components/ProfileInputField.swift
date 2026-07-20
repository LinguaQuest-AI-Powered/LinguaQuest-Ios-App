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
    @Binding var text: String
    
    init(title: String, placeholder: String, icon: Image.SystemIcon, isMultiline: Bool = false, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self.isMultiline = isMultiline
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .appTextStyle(.body, color: .appIconBrown)
            
            HStack(alignment: isMultiline ? .bottom : .center, spacing: 12) {
                if isMultiline {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(Color.appTextSecondary.opacity(0.5)),
                        axis: .vertical
                    )
                    .lineLimit(4, reservesSpace: true)
                    .appTextStyle(.body, color: .appTextHeading)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                } else {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(Color.appTextSecondary.opacity(0.5))
                    )
                    .appTextStyle(.body, color: .appTextHeading)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
                
                Image(systemIcon: icon)
                    .foregroundColor(.appBorderBrown)
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, isMultiline ? 16 : 0)
            .frame(height: isMultiline ? nil : 56)
            .background(Color.appSurfaceNavBar) // Light warm background
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
                title: "Explorer's Tagline",
                placeholder: "Mapping the wild frontiers of the French language, one word at a time!",
                icon: .squareAndPencil,
                isMultiline: true,
                text: .constant("")
            )
        }
        .padding()
    }
}
