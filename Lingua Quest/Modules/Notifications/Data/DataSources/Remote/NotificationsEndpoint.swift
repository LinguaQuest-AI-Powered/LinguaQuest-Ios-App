//
//  NotificationsEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

enum NotificationsEndpoint {
    struct RegisterDevice: Endpoint {
        let token: String
        var path: String { "/devices" } // Based on API docs it's /devices not /api/v1/devices, but base URL might handle the /api/v1 prefix
        var method: HTTPMethod { .post }
        var body: DeviceTokenRequestDTO? { DeviceTokenRequestDTO(token: token, platform: "IOS") }
    }
    
    struct UnregisterDevice: Endpoint {
        let token: String
        var path: String { "/devices" }
        var method: HTTPMethod { .delete }
        var body: DeviceTokenRequestDTO? { DeviceTokenRequestDTO(token: token, platform: "IOS") }
    }
    
    struct GetNotifications: Endpoint {
        let page: Int
        let size: Int
        var path: String { "/notifications" }
        var method: HTTPMethod { .get }
        var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
        }
        var body: EmptyBody? { nil }
    }
    
    struct DeleteAllNotifications: Endpoint {
        var path: String { "/notifications" }
        var method: HTTPMethod { .delete }
        var body: EmptyBody? { nil }
    }
    
    struct GetUnreadCount: Endpoint {
        var path: String { "/notifications/unread-count" }
        var method: HTTPMethod { .get }
        var body: EmptyBody? { nil }
    }
    
    struct MarkAsRead: Endpoint {
        let id: Int
        var path: String { "/notifications/\(id)/read" }
        var method: HTTPMethod { .patch }
        var body: EmptyBody? { nil }
    }
    
    struct DeleteNotification: Endpoint {
        let id: Int
        var path: String { "/notifications/\(id)" }
        var method: HTTPMethod { .delete }
        var body: EmptyBody? { nil }
    }
}
