
import Observation
import SwiftUI

@Observable
final class EditProfileViewModel {
    // MARK: - Dependencies
    private let getProfileUseCase: GetProfileUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let uploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol
    private let changePasswordUseCase: ChangePasswordUseCaseProtocol

    // MARK: - Tab State
    var selectedTab: EditProfileTab = .personalInfo

    // MARK: - Form State
    var displayName: String = ""

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

    // MARK: - Change Password State
    var oldPassword: String = ""
    var newPassword: String = ""
    var isChangingPassword: Bool = false
    var passwordErrorMessage: String? = nil
    var passwordChangeSucceeded: Bool = false

    // MARK: - Init
    init(
        getProfileUseCase: GetProfileUseCaseProtocol,
        updateProfileUseCase: UpdateProfileUseCaseProtocol,
        uploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol,
        changePasswordUseCase: ChangePasswordUseCaseProtocol
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.uploadProfilePhotoUseCase = uploadProfilePhotoUseCase
        self.changePasswordUseCase = changePasswordUseCase
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
                        self.avatarImage = AppConfig.resolveURL(url)
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
                    let fullUrl = AppConfig.resolveURL(photoUrl)
                    self.avatarImage = fullUrl
                    UserDefaults.standard.set(fullUrl, forKey: AppConstants.UserDefaultsKeys.cachedAvatarUrl)
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

    // MARK: - Save Profile

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
                    self.errorMessage = (error as? NetworkError)?.apiErrorMessage ?? error.localizedDescription
                    self.isSaving = false
                }
            }
        }
    }

    // MARK: - Change Password

    var canChangePassword: Bool {
        !oldPassword.isEmpty && newPassword.count >= 8 && newPassword.count <= 64
    }

    var canSaveProfile: Bool {
        !displayName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func changePassword() {
        guard canChangePassword else { return }

        if oldPassword == newPassword {
            passwordErrorMessage = L10n.Auth.Error.samePasswordAsOld
            return
        }

        isChangingPassword = true
        passwordErrorMessage = nil

        Task {
            do {
                try await changePasswordUseCase.execute(
                    oldPassword: oldPassword,
                    newPassword: newPassword
                )
                await MainActor.run {
                    self.isChangingPassword = false
                    self.passwordChangeSucceeded = true
                    self.oldPassword = ""
                    self.newPassword = ""
                }
            } catch {
                await MainActor.run {
                    self.passwordErrorMessage = (error as? NetworkError)?.apiErrorMessage ?? error.localizedDescription
                    self.isChangingPassword = false
                }
            }
        }
    }
}

// MARK: - Tab

enum EditProfileTab: CaseIterable {
    case personalInfo
    case security

    var title: String {
        switch self {
        case .personalInfo: return L10n.EditProfile.tabPersonalInfo
        case .security:     return L10n.EditProfile.tabSecurity
        }
    }
}
