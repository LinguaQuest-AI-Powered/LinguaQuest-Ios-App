

import Observation
import SwiftUI

@Observable
final class EditProfileViewModel {
    // MARK: - Dependencies
    private let getProfileUseCase: GetProfileUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let uploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol

    // MARK: - Form State
    var displayName: String = ""
    var tagline: String = ""

    // MARK: - Photo State
    var avatarImage: String? = nil
    var showPhotoSourcePicker: Bool = false
    var showCameraPicker: Bool = false
    var showGalleryPicker: Bool = false
    var isUploadingPhoto: Bool = false

    // MARK: - Load / Save State
    var isLoading: Bool = false
    var isSaving: Bool = false
    var errorMessage: String? = nil
    var saveSucceeded: Bool = false

    // MARK: - Init
    init(
        getProfileUseCase: GetProfileUseCaseProtocol,
        updateProfileUseCase: UpdateProfileUseCaseProtocol,
        uploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.uploadProfilePhotoUseCase = uploadProfilePhotoUseCase
    }

    // MARK: - Load Profile

    func loadProfile() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profile = try await getProfileUseCase.execute()
                await MainActor.run {
                    self.displayName = profile.username
                    if let url = profile.avatarUrl, !url.isEmpty {
                        self.avatarImage = url
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    // MARK: - Photo Intentions

    func onChangePhotoTapped() {
        showPhotoSourcePicker = true
    }

    func selectSourceCamera() {
        showPhotoSourcePicker = false
        showCameraPicker = true
    }

    func selectSourceGallery() {
        showPhotoSourcePicker = false
        showGalleryPicker = true
    }

    func uploadPhoto(image: UIImage) {
        let resizedImage = image.resizedForAvatar(maxDimension: 512)
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.8) else { return }

        isUploadingPhoto = true
        errorMessage = nil

        Task {
            do {
                let photoUrl = try await uploadProfilePhotoUseCase.execute(imageData: imageData, mimeType: "image/jpeg")
                await MainActor.run {
                    self.avatarImage = photoUrl
                    self.isUploadingPhoto = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isUploadingPhoto = false
                }
            }
        }
    }

    // MARK: - Save Intention

    func saveChanges() {
        let trimmed = displayName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        isSaving = true
        errorMessage = nil

        Task {
            do {
                let updatedUsername = try await updateProfileUseCase.execute(username: trimmed)
                await MainActor.run {
                    self.displayName = updatedUsername
                    self.isSaving = false
                    self.saveSucceeded = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isSaving = false
                }
            }
        }
    }
}

// MARK: - UIImage resize helper
private extension UIImage {
    func resizedForAvatar(maxDimension: CGFloat = 512) -> UIImage {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return self }
        let ratio = maxDimension / maxSide
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
