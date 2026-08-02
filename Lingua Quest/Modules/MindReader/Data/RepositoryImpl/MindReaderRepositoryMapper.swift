//
//  MindReaderRepositoryMapper.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

extension GameCategoryDTO {
    func toDomain() -> GameCategory {
        return GameCategory(
            id: id,
            key: key,
            nativeName: nativeName,
            targetName: targetName,
            emoji: emoji,
            promptContext: promptContext
        )
    }
}

extension AkinatorStepResponseDTO {
    func toDomain() throws -> AIGameDecision {
        if type == "question" {
            guard let qTarget = questionTargetText, let qNative = questionNativeText else {
                throw NSError(domain: "MindReaderMapper", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing question texts for question type"])
            }
            return .question(targetText: qTarget, nativeText: qNative)
        } else if type == "guess" {
            guard let word = guessWord, let translation = guessTranslation, let emoji = guessEmoji else {
                throw NSError(domain: "MindReaderMapper", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing guess fields for guess type"])
            }
            return .guess(word: word, translation: translation, emoji: emoji)
        } else {
            throw NSError(domain: "MindReaderMapper", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown decision type: \(type)"])
        }
    }
}

extension QuizChoiceDTO {
    func toDomain() -> QuizChoice {
        return QuizChoice(
            translationText: translationText,
            isCorrect: isCorrect
        )
    }
}

extension HonestyResponseDTO {
    func toDomain() -> HonestyVerdict {
        return HonestyVerdict(
            isHonest: isHonest,
            explanation: explanation
        )
    }
}
