//
//  ExplorerUIModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct ExplorerUIModel: Identifiable {
    let id: String
    let name: String
    let uiRank: String
    let uiXPAmount: String
    let avatarImage: String?
    let isTop: Bool
    let isCurrentUser: Bool
}
