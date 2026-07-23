//
//  EditProfileAvatarSection.swift
//  LinguaQuest
//

import SwiftUI

struct EditProfileAvatarSection: View {
    let avatarImage: String?
    let isUploading: Bool
    let onChangePhoto: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                // Avatar image
                Group {
                    if let url = avatarImage, url.hasPrefix("http"), let imageURL = URL(string: url) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            default:
                                Image(asset: .bird)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    } else {
                        Image(asset: .bird)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 120, height: 120)
                .background(Color.appSurfaceCardWarm)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.appBrandPrimary, lineWidth: 4)
                )
                .overlay {
                    if isUploading {
                        Circle()
                            .fill(Color.black.opacity(0.35))
                        ProgressView()
                            .tint(.white)
                    }
                }

                // Edit pencil button
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
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
                .disabled(isUploading)
                .offset(x: -4, y: -4)
            }

            Button {
                onChangePhoto()
            } label: {
                Text(L10n.EditProfile.changePhoto)
                    .appTextStyle(.bodyBold, color: .appBrandBrownDark)
            }
            .disabled(isUploading)
        }
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()
        EditProfileAvatarSection(avatarImage: nil, isUploading: false, onChangePhoto: {})
    }
}
