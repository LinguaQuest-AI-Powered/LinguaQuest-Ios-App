//
//  NotificationsRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

final class NotificationsRemoteDataSource: NotificationsRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func registerDevice(token: String) async -> Result<Void, NetworkError> {
        do {
            // Re-using the backend's generic success status logic if they have StatusResponseDataDTO
            // If they just return success: true and data: { "status": "success" }
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                NotificationsEndpoint.RegisterDevice(token: token)
            )
            return .success(())
        } catch {
            return .failure(error as? NetworkError ?? .unknown(error))
        }
    }

    func unregisterDevice(token: String) async -> Result<Void, NetworkError> {
        do {
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                NotificationsEndpoint.UnregisterDevice(token: token)
            )
            return .success(())
        } catch {
            return .failure(error as? NetworkError ?? .unknown(error))
        }
    }

    func getNotifications(page: Int, size: Int) async -> Result<NotificationsPageDTO, NetworkError> {
        do {
            let response: SuccessResponseDTO<NotificationsPageDTO> = try await apiClient.request(
                NotificationsEndpoint.GetNotifications(page: page, size: size)
            )
            return .success(response.data)
        } catch {
            return .failure(error as? NetworkError ?? .unknown(error))
        }
    }

    func deleteAllNotifications() async -> Result<Void, NetworkError> {
        do {
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                NotificationsEndpoint.DeleteAllNotifications()
            )
            return .success(())
        } catch {
            return .failure(error as? NetworkError ?? .unknown(error))
        }
    }

    func getUnreadCount() async -> Result<UnreadCountDTO, NetworkError> {
        do {
            let response: SuccessResponseDTO<UnreadCountDTO> = try await apiClient.request(
                NotificationsEndpoint.GetUnreadCount()
            )
            return .success(response.data)
        } catch {
            return .failure(error as? NetworkError ?? .unknown(error))
        }
    }

    func markAsRead(id: Int) async -> Result<Void, NetworkError> {
        do {
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                NotificationsEndpoint.MarkAsRead(id: id)
            )
            return .success(())
        } catch {
            return .failure(error as? NetworkError ?? .unknown(error))
        }
    }

    func deleteNotification(id: Int) async -> Result<Void, NetworkError> {
        do {
            let _: SuccessResponseDTO<StatusResponseDataDTO> = try await apiClient.request(
                NotificationsEndpoint.DeleteNotification(id: id)
            )
            return .success(())
        } catch {
            return .failure(error as? NetworkError ?? .unknown(error))
        }
    }
}
