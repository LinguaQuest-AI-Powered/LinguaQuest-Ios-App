//
//  EditProfileFormSection.swift
//  LinguaQuest
//

import SwiftUI

struct EditProfileFormSection: View {
    @Binding var displayName: String
    
    var body: some View {
        VStack(spacing: 20) {
            ProfileInputField(
                title: L10n.EditProfile.displayName,
                placeholder: L10n.EditProfile.displayNamePlaceholder,
                icon: .person,
                text: $displayName
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
        EditProfileFormSection(displayName: .constant(""))
            .padding()
    }
}
