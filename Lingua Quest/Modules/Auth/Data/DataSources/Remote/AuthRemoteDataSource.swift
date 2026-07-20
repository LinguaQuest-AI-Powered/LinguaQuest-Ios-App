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
}
