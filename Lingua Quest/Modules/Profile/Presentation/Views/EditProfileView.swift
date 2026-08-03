//
//  EditProfileView.swift
//  LinguaQuest
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: EditProfileViewModel

    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Navigation Bar
                HStack {
                    CustomBackButton { dismiss() }
                    Spacer()
                }
                .overlay(
                    Text(L10n.EditProfile.title)
                        .appTextStyle(.headingLarge, color: .appTextHeading)
                )
                .padding(.horizontal, 20)
                .frame(height: 64)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.appBorderBrown),
                    alignment: .bottom
                )

                // MARK: - Avatar (always visible)
                EditProfileAvatarSection(
                    avatarImage: viewModel.avatarImage,
                    isUploading: viewModel.isUploadingPhoto || viewModel.isLoading,
                    onChangePhoto: { viewModel.onChangePhotoTapped() }
                )
                .padding(.top, 20)

                // MARK: - Tab Bar
                EditProfileTabBar(selectedTab: $viewModel.selectedTab)
                    .padding(.top, 16)
                    .padding(.horizontal, 24)

                // MARK: - Tab Content
                ScrollView {
                    VStack(spacing: 24) {
                        switch viewModel.selectedTab {
                        case .personalInfo:
                            personalInfoContent

                        case .security:
                            securityContent
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedTab)
            }

            // MARK: - Loading Overlay
            if viewModel.isSaving || viewModel.isChangingPassword {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.loadProfile() }
        // Photo Source Picker
        .sheet(isPresented: $viewModel.showPhotoSourcePicker) {
            CustomBottomSheet(isPresented: $viewModel.showPhotoSourcePicker, initialDetent: .custom(ratio: 0.42)) {
                ProfilePhotoSourceBottomSheet(
                    onCameraSelected: { viewModel.selectSourceCamera() },
                    onGallerySelected: { viewModel.selectSourceGallery() },
                    onCancelSelected: { viewModel.showPhotoSourcePicker = false }
                )
            }
        }
        // Camera
        .fullScreenCover(isPresented: $viewModel.showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                viewModel.uploadPhoto(image: image)
            }
            .ignoresSafeArea()
        }
        // Gallery
        .sheet(isPresented: $viewModel.showGalleryPicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                viewModel.uploadPhoto(image: image)
            }
        }
        // Dismiss when profile save succeeds
        .onChange(of: viewModel.saveSucceeded) { _, succeeded in
            if succeeded { dismiss() }
        }
        // Dismiss when password change succeeds
        .onChange(of: viewModel.passwordChangeSucceeded) { _, succeeded in
            if succeeded { dismiss() }
        }
    }

    // MARK: - Personal Info Tab

    private var personalInfoContent: some View {
        VStack(spacing: 24) {
            EditProfileFormSection(displayName: $viewModel.displayName)

            if let error = viewModel.errorMessage {
                Text(error)
                    .appTextStyle(.body, color: .red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            EditProfileActionsSection(
                onSave: { viewModel.saveChanges() },
                onCancel: { dismiss() },
                saveStatus: viewModel.canSaveProfile ? .enable : .disable
            )
        }
    }

    // MARK: - Security Tab

    private var securityContent: some View {
        VStack(spacing: 24) {
            ChangePasswordSection(
                oldPassword: $viewModel.oldPassword,
                newPassword: $viewModel.newPassword
            )

            if let error = viewModel.passwordErrorMessage {
                Text(error)
                    .appTextStyle(.body, color: .red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            VStack(spacing: 16) {
                CustomButton(
                    type: .primary,
                    text: L10n.EditProfile.saveChanges,
                    action: { viewModel.changePassword() },
                    status: viewModel.canChangePassword ? .enable : .disable
                )

                Button { dismiss() } label: {
                    Text(L10n.EditProfile.cancel)
                        .appTextStyle(.bodyBold, color: .appTextSecondary)
                }
                .padding(.vertical, 8)
            }
        }
    }
}
