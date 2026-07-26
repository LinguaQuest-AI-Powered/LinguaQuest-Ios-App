//
//  BossEvaluationResult.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

struct BossEvaluationResult: Codable, Equatable {
    let task_completed: Bool
    let fluency_score: Int
    let feedback_message: String
}
