//
//  DailyRewardDayUIModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

enum DailyRewardDayStatus: Equatable {
    case completed
    case current
    case locked
}

struct DailyRewardDayUIModel: Identifiable {
    let id = UUID()
    let day: Int
    let status: DailyRewardDayStatus
}
