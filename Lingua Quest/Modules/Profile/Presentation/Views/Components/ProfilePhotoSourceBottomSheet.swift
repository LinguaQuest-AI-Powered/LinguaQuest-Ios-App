

import SwiftUI

struct ProfilePhotoSourceBottomSheet: View {
    let onCameraSelected: () -> Void
    let onGallerySelected: () -> Void
    let onCancelSelected: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text(L10n.EditProfile.choosePhotoSource)
                .appTextStyle(.headingMedium, color: .appBrandBrownDark)
                .padding(.top, 8)

            HStack(spacing: 16) {
                SourceOptionCard(
                    title: L10n.EditProfile.camera,
                    iconSystemName: .cameraFill,
                    backgroundColor: Color.appBrandPrimary.opacity(0.15),
                    accentColor: .appBrandBrownDark,
                    action: onCameraSelected
                )

                SourceOptionCard(
                    title: L10n.EditProfile.gallery,
                    iconSystemName: .photoOnRectangleFill,
                    backgroundColor: Color.appAccentTeal.opacity(0.15),
                    accentColor: .appAccentTeal,
                    action: onGallerySelected
                )
            }
            .padding(.horizontal, 20)

            CustomButton(
                type: .secendry,
                text: L10n.EditProfile.cancel,
                action: onCancelSelected
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 24)

        }
        .padding(.top, 16)
    }
}

// MARK: - SourceOptionCard Component
private struct SourceOptionCard: View {
    let title: String
    let iconSystemName: Image.SystemIcon
    let backgroundColor: Color
    let accentColor: Color
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 60, height: 60)

                    Image(systemIcon: iconSystemName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(accentColor)
                }

                Text(title)
                    .appTextStyle(.bodyBold, color: .appTextHeading)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.appSurfaceCardWarm)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.appBorderBrown.opacity(0.3), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = true } }
                .onEnded { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = false } }
        )
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()

        CustomBottomSheet(isPresented: .constant(true), initialDetent: .custom(ratio: 0.42)) {
            ProfilePhotoSourceBottomSheet(
                onCameraSelected: {},
                onGallerySelected: {},
                onCancelSelected: {}
            )
        }
    }
}
