//
//  EditProfileFormSection.swift
//  LinguaQuest
//

import SwiftUI

struct EditProfileFormSection: View {
    @Binding var displayName: String
    @Binding var tagline: String
    
    var body: some View {
        VStack(spacing: 20) {
            ProfileInputField(
                title: L10n.EditProfile.displayName,
                placeholder: L10n.EditProfile.displayNamePlaceholder,
                icon: .person,
                text: $displayName
            )
            
            ProfileInputField(
                title: L10n.EditProfile.tagline,
                placeholder: L10n.EditProfile.taglinePlaceholder,
                icon: .squareAndPencil,
                isMultiline: true,
                text: $tagline
            )
        }
        .padding(20)
        .background(Color.appSurfaceCardWarm)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()
        EditProfileFormSection(displayName: .constant(""), tagline: .constant(""))
            .padding()
    }
}
