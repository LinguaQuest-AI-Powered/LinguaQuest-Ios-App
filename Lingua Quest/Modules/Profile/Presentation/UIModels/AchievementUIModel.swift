//
//  AchievementUIModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct AchievementUIModel: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let uiIcon: Image.SystemIcon
    let uiIconColor: Color
    let uiBgColor: Color
    let iconUrl: String?
    let status: AchievementStatus
    let progressPercent: Int
    let xpReward: Int
    let coinsReward: Int
    let earnedAt: String?
    
    init(
        id: String,
        title: String,
        subtitle: String,
        uiIcon: Image.SystemIcon,
        uiIconColor: Color,
        uiBgColor: Color,
        iconUrl: String? = nil,
        status: AchievementStatus = .earned,
        progressPercent: Int = 100,
        xpReward: Int = 0,
        coinsReward: Int = 0,
        earnedAt: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.uiIcon = uiIcon
        self.uiIconColor = uiIconColor
        self.uiBgColor = uiBgColor
        self.iconUrl = iconUrl
        self.status = status
        self.progressPercent = progressPercent
        self.xpReward = xpReward
        self.coinsReward = coinsReward
        self.earnedAt = earnedAt
    }
    
    var isEarned: Bool {
        return status.isEarned
    }
}
