//
//  RoleplayMessage.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

enum MessageSender: String, Codable {
    case user
    case ai
}

struct RoleplayMessage: Identifiable, Equatable {
    let id: UUID
    let sender: MessageSender
    var text: String
    let timestamp: Date

    init(id: UUID = UUID(), sender: MessageSender, text: String, timestamp: Date = Date()) {
        self.id = id
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
    }
}
