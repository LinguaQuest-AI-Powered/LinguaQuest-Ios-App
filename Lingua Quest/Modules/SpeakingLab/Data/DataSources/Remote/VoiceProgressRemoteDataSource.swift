//
//  VoiceProgressRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import FirebaseFirestore

protocol VoiceProgressRemoteDataSourceProtocol {
    func getTodaySentences(userId: String, languageCode: String) async throws -> [VoiceSentenceDTO]?
    func saveDailySentences(userId: String, languageCode: String, sentences: [VoiceSentenceDTO]) async throws
    func markSentenceCompleted(userId: String, languageCode: String, sentenceId: String) async throws
    func getProgress(userId: String, languageCode: String) async throws -> (completed: Int, total: Int)
}

class VoiceProgressRemoteDataSource: VoiceProgressRemoteDataSourceProtocol {
    private let db = Firestore.firestore()
    
    private var todayDateId: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func dailyDocRef(userId: String, languageCode: String) -> DocumentReference {
        db.collection("users").document(userId)
            .collection("voice_daily_\(languageCode)").document(todayDateId)
    }
    
    func getTodaySentences(userId: String, languageCode: String) async throws -> [VoiceSentenceDTO]? {
        let docRef = dailyDocRef(userId: userId, languageCode: languageCode)
        let snapshot = try await docRef.getDocument()
        
        guard snapshot.exists, let data = snapshot.data(),
              let sentencesArray = data["sentences"] as? [[String: Any]] else {
            return nil
        }
        
        let sentences: [VoiceSentenceDTO] = sentencesArray.map { dict in
            VoiceSentenceDTO.fromDictionary(dict)
        }
        
        return sentences.isEmpty ? nil : sentences
    }
    
    func saveDailySentences(userId: String, languageCode: String, sentences: [VoiceSentenceDTO]) async throws {
        let docRef = dailyDocRef(userId: userId, languageCode: languageCode)
        
        let sentenceDicts = sentences.map { $0.toDictionary() }
        
        try await docRef.setData([
            "sentences": sentenceDicts,
            "completed_sentence_ids": [String](),
            "created_at": FieldValue.serverTimestamp()
        ])
    }
    
    func markSentenceCompleted(userId: String, languageCode: String, sentenceId: String) async throws {
        let docRef = dailyDocRef(userId: userId, languageCode: languageCode)
        
        try await docRef.updateData([
            "completed_sentence_ids": FieldValue.arrayUnion([sentenceId]),
            "last_updated": FieldValue.serverTimestamp()
        ])
    }
    
    func getProgress(userId: String, languageCode: String) async throws -> (completed: Int, total: Int) {
        let docRef = dailyDocRef(userId: userId, languageCode: languageCode)
        let snapshot = try await docRef.getDocument()
        
        guard snapshot.exists, let data = snapshot.data() else {
            return (completed: 0, total: 5)
        }
        
        let completedIds = data["completed_sentence_ids"] as? [String] ?? []
        let sentences = data["sentences"] as? [[String: Any]] ?? []
        
        return (completed: completedIds.count, total: max(sentences.count, 5))
    }
}
