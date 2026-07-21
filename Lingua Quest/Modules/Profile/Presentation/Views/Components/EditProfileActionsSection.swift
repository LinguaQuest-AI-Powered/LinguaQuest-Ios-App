//
//  EditProfileActionsSection.swift
//  LinguaQuest
//

import SwiftUI

struct EditProfileActionsSection: View {
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemIcon: .infoCircle)
                    .foregroundColor(.appTextSecondary)
                    .font(.system(size: 14))
                    .padding(.top, 2)
                
                Text(L10n.EditProfile.infoText)
                    .appTextStyle(.captionMedium, color: .appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 8)
            
            VStack(spacing: 16) {
                CustomButton(
                    type: .primary,
                    text: L10n.EditProfile.saveChanges,
                    action: onSave
                )
                
                Button {
                    onCancel()
                } label: {
                    Text(L10n.EditProfile.cancel)
                        .appTextStyle(.bodyBold, color: .appTextSecondary)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()
        EditProfileActionsSection(onSave: {}, onCancel: {})
            .padding()
    }
}
