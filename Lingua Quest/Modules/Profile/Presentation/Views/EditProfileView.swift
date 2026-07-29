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
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.appBorderBrown),
                    alignment: .bottom
                )

                // MARK: - Content
                ScrollView {
                    VStack(spacing: 32) {
                        EditProfileAvatarSection(
                            avatarImage: viewModel.avatarImage,
                            isUploading: viewModel.isUploadingPhoto || viewModel.isLoading,
                            onChangePhoto: {
                                viewModel.onChangePhotoTapped()
                            }
                        )
                        .padding(.top, 16)

                        EditProfileFormSection(
                            displayName: $viewModel.displayName
                        )

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .appTextStyle(.body, color: .red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                        }

                        EditProfileActionsSection(
                            onSave: {
                                viewModel.saveChanges()
                            },
                            onCancel: {
                                dismiss()
                            }
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }

            // MARK: - Saving Overlay
            if viewModel.isSaving {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadProfile()
        }
        // MARK: - Photo Source Picker Sheet
        .sheet(isPresented: $viewModel.showPhotoSourcePicker) {
            CustomBottomSheet(isPresented: $viewModel.showPhotoSourcePicker, initialDetent: .custom(ratio: 0.42)) {
                ProfilePhotoSourceBottomSheet(
                    onCameraSelected: { viewModel.selectSourceCamera() },
                    onGallerySelected: { viewModel.selectSourceGallery() },
                    onCancelSelected: { viewModel.showPhotoSourcePicker = false }
                )
            }
        }
        // MARK: - Camera Picker
        .fullScreenCover(isPresented: $viewModel.showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                viewModel.uploadPhoto(image: image)
            }
            .ignoresSafeArea()
        }
        // MARK: - Gallery Picker
        .sheet(isPresented: $viewModel.showGalleryPicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                viewModel.uploadPhoto(image: image)
            }
        }
        // MARK: - Dismiss on Save Success
        .onChange(of: viewModel.saveSucceeded) { _, succeeded in
            if succeeded { dismiss() }
        }
    }
}
