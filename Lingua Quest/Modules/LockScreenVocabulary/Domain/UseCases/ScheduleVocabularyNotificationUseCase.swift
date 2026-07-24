//
//  ScheduleVocabularyNotificationUseCase.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

protocol ScheduleVocabularyNotificationUseCaseProtocol {
    func execute(word: VocabularyWordEntity)
}

final class ScheduleVocabularyNotificationUseCase: ScheduleVocabularyNotificationUseCaseProtocol {
    func execute(word: VocabularyWordEntity) {
        LocalNotificationManager.shared.scheduleVocabularyNotification(word: word.word, meaning: word.meaning, wordId: word.id)
    }
}
