//
//  AuthRemoteDataSource.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

final class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func login(email: String, password: String) async -> Result<(session: AuthSessionEntity, user: UserEntity), AuthError> {
        do {
            let response: SuccessResponseDTO<LoginResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.Login(email: email, password: password)
            )
            return .success(AuthDTOMapper.mapLogin(response.data))
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }

    func register(
        email: String, username: String, password: String,
        nativeLanguage: String, targetLanguage: String
    ) async -> Result<RegisteredAccountEntity, AuthError> {
        do {
            let response: SuccessResponseDTO<RegisterResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.Register(
                    email: email, username: username, password: password,
                    nativeLanguage: nativeLanguage, targetLanguage: targetLanguage
                )
            )
            return .success(AuthDTOMapper.mapRegister(response.data))
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }

    func sendOtp(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError> {
        do {
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.SendOtp(email: email, purpose: purpose)
            )
            return .success(())
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }

    func verifySignupOtp(email: String, otp: String) async -> Result<Bool, AuthError> {
        do {
            let response: SuccessResponseDTO<VerifySignupOtpResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.VerifySignupOtp(email: email, otp: otp)
            )
            return .success(AuthDTOMapper.mapVerifySignupOtp(response.data))
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }
    
    func verifyPasswordResetOtp(email: String, otp: String) async -> Result<(resetToken: String, expiresIn: Int), AuthError> {
        do {
            let response: SuccessResponseDTO<VerifyPasswordResetOtpResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.VerifyPasswordResetOtp(email: email, otp: otp)
            )
            return .success(AuthDTOMapper.mapVerifyPasswordResetOtp(response.data))
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }

    func resetPassword(resetToken: String, newPassword: String) async -> Result<Void, AuthError> {
        do {
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.ResetPassword(resetToken: resetToken, newPassword: newPassword)
            )
            return .success(())
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }
    
    func refreshToken(refreshToken: String) async -> Result<AuthSessionEntity, AuthError> {
        do {
            let response: SuccessResponseDTO<RefreshTokenResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.RefreshToken(refreshToken: refreshToken)
            )
            return .success(AuthDTOMapper.mapRefreshToken(response.data))
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }
    
    func logout(refreshToken: String, allDevices: Bool) async -> Result<Void, AuthError> {
        do {
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.Logout(refreshToken: refreshToken, allDevices: allDevices)
            )
            return .success(())
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }
    
    func loginWithFirebase(idToken: String) async -> Result<(session: AuthSessionEntity, user: UserEntity, profileComplete: Bool), AuthError> {
        do {
            let response: SuccessResponseDTO<OAuthResponseDataDTO> = try await apiClient.request(
                AuthEndpoint.FirebaseLogin(idToken: idToken)
            )
            return .success(AuthDTOMapper.mapOAuthLogin(response.data))
        } catch {
            return .failure(AuthDTOMapper.mapError(error))
        }
    }
}
