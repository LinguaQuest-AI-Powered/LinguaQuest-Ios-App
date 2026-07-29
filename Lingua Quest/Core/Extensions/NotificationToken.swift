//
//  NotificationToken.swift
//  Lingua Quest
//
//  Created by AI on 2026-07-29.
//

import Foundation

public final class NotificationToken: @unchecked Sendable {
    private let token: Any
    private let center: NotificationCenter

    public init(token: Any, center: NotificationCenter = .default) {
        self.token = token
        self.center = center
    }

    deinit {
        center.removeObserver(token)
    }
}
