//
//  EditProfileAvatarSection.swift
//  LinguaQuest
//

import SwiftUI

struct EditProfileAvatarSection: View {
    let onChangePhoto: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                Image(asset: .bird)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .background(Color.appSurfaceCardWarm)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.appBrandPrimary, lineWidth: 4)
                    )
                
                Button {
                    onChangePhoto()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.appTextHeading)
                            .frame(width: 32, height: 32)
                        
                        Image(systemIcon: .pencil)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                }
                .offset(x: -4, y: -4)
            }
            
            Button {
                onChangePhoto()
            } label: {
                Text(L10n.EditProfile.changePhoto)
                    .appTextStyle(.bodyBold, color: .appBrandBrownDark)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()
        EditProfileAvatarSection(onChangePhoto: {})
    }
}
