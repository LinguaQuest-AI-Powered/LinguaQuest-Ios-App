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
    let grammar_score: Int
    let vocabulary_score: Int
    let feedback_message: String
    let what_went_well: [String]
    let areas_to_improve: [String]
    
    var earnedStars: Int {
        if !task_completed { return 0 }
        let avg = (fluency_score + grammar_score + vocabulary_score) / 3
        if avg >= 90 { return 3 }
        if avg >= 70 { return 2 }
        if avg >= 50 { return 1 }
        return 0
    }
    
    var reward: MiniGameReward? {
        switch earnedStars {
        case 3: return .roleplay3Stars
        case 2: return .roleplay2Stars
        case 1: return .roleplay1Star
        default: return nil
        }
    }
}
