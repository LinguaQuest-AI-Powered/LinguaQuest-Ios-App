//
//  VoiceProgressRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import FirebaseFirestore

protocol VoiceProgressRemoteDataSourceProtocol {
    func getDailySentences() async throws -> [VoiceSentence]
    func saveSentenceProgress(userId: String, sentenceId: String, result: VoiceEvaluationResponseDTO) async throws
}

class VoiceProgressRemoteDataSource: VoiceProgressRemoteDataSourceProtocol {
    private let db = Firestore.firestore()
    
    func getDailySentences() async throws -> [VoiceSentence] {
        // Hardcoded for now as requested, until we have a real backend collection
        return [
            VoiceSentence(id: "1", text: "The quick brown fox jumps over the lazy dog.", translation: "الثعلب البني السريع يقفز فوق الكلب الكسول.", difficulty: "Medium"),
            VoiceSentence(id: "2", text: "I would like a cup of coffee, please.", translation: "أريد فنجان قهوة من فضلك.", difficulty: "Easy"),
            VoiceSentence(id: "3", text: "Where is the nearest train station?", translation: "أين تقع أقرب محطة قطار؟", difficulty: "Easy"),
            VoiceSentence(id: "4", text: "Learning a new language opens many doors.", translation: "تعلم لغة جديدة يفتح أبواباً كثيرة.", difficulty: "Medium"),
            VoiceSentence(id: "5", text: "It's a beautiful day to go for a walk.", translation: "إنه يوم جميل للذهاب في نزهة.", difficulty: "Easy")
        ]
    }
    
    func saveSentenceProgress(userId: String, sentenceId: String, result: VoiceEvaluationResponseDTO) async throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateId = formatter.string(from: Date())
        
        let docRef = db.collection("users").document(userId).collection("voice_progress").document(dateId)
        
        try await docRef.setData([
            "completed_sentences": FieldValue.arrayUnion([sentenceId]),
            "last_updated": FieldValue.serverTimestamp(),
            "results": [
                sentenceId: [
                    "rating": result.rating,
                    "correct_words": result.correct_words,
                    "wrong_words": result.wrong_words,
                    "advice": result.advice
                ]
            ]
        ], merge: true)
    }
}
