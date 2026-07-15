//
//  UserPreferences.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation
import SwiftUI

protocol UserPreferencesProtocol {
    var isOnboardingCompleted: Bool { get set }
    var spokenLanguageCode: String? { get set }
    var learningLanguageCode: String? { get set }
    var userLevel: String? { get set }
}

final class UserPreferences: UserPreferencesProtocol {
    private let defaults = UserDefaults.standard
    
    var isOnboardingCompleted: Bool {
        get { defaults.bool(forKey: "isOnboardingCompleted") }
        set { defaults.set(newValue, forKey: "isOnboardingCompleted") }
    }
    
    var spokenLanguageCode: String? {
        get { defaults.string(forKey: "spokenLanguageCode") }
        set { defaults.set(newValue, forKey: "spokenLanguageCode") }
    }
    
    var learningLanguageCode: String? {
        get { defaults.string(forKey: "learningLanguageCode") }
        set { defaults.set(newValue, forKey: "learningLanguageCode") }
    }
    
    var userLevel: String? {
        get { defaults.string(forKey: "userLevel") }
        set { defaults.set(newValue, forKey: "userLevel") }
    }
}
