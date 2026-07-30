//
//  Notification+Ext.swift
//  Lingua Quest
//
//  Created by siam on 30/07/2026.
//

import Foundation

extension Notification.Name {
    /// Posted when a refresh attempt fails and the session is truly over —
    /// RootView/Router should observe this and force navigation to Login.
    static let sessionExpired = Notification.Name("com.linguaquest.sessionExpired")
    
    /// Posted when the user explicitly logs out or the session ends,
    /// so that local caches and view models can be cleared.
    static let userDidLogout = Notification.Name("com.linguaquest.userDidLogout")
    
    /// Posted when a user successfully completes a level and progress is saved to Firebase.
    /// Observers (like Home) should refresh their progress and stats.
    static let progressDidUpdate = Notification.Name("com.linguaquest.progressDidUpdate")
    
    /// Posted when the user taps "Continue" after successfully completing a Voice Game level.
    /// Instructs the Voice Game to advance to the next sentence.
    static let voiceGameDidAdvanceLevel = Notification.Name("com.linguaquest.voiceGameDidAdvanceLevel")
}
