//
//  LockScreenSettingsRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 27/07/2026.
//

import Foundation
import FirebaseFirestore

protocol LockScreenSettingsRemoteDataSourceProtocol {
    func isUnlocked(userId: Int) async throws -> Bool
    func setUnlocked(userId: Int) async throws
}

class LockScreenSettingsRemoteDataSource: LockScreenSettingsRemoteDataSourceProtocol {
    private let db = Firestore.firestore()
    
    func isUnlocked(userId: Int) async throws -> Bool {
        let docRef = db.collection("users").document("\(userId)")
        let snapshot = try await docRef.getDocument()
        guard snapshot.exists, let data = snapshot.data() else {
            return false
        }
        return data["hasUnlockedLockScreenVocab"] as? Bool ?? false
    }
    
    func setUnlocked(userId: Int) async throws {
        let docRef = db.collection("users").document("\(userId)")
        try await docRef.setData(["hasUnlockedLockScreenVocab": true], merge: true)
    }
}
