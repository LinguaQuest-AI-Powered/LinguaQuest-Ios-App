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
    var isLoggedIn: Bool { get set }
    var needsProfileCompletion: Bool { get set }
    var spokenLanguageCode: String? { get set }
    var learningLanguageCode: String? { get set }
    var userLevel: String? { get set }
}

final class UserPreferences: UserPreferencesProtocol {
    private let defaults = UserDefaults.standard
    
    var isOnboardingCompleted: Bool {
        get { defaults.bool(forKey: AppConstants.UserDefaultsKeys.isOnboardingCompleted) }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.isOnboardingCompleted) }
    }
    
    var spokenLanguageCode: String? {
        get { defaults.string(forKey: AppConstants.UserDefaultsKeys.spokenLanguageCode) }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.spokenLanguageCode) }
    }
    
    var learningLanguageCode: String? {
        get { defaults.string(forKey: AppConstants.UserDefaultsKeys.learningLanguageCode) }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.learningLanguageCode) }
    }
    
    var userLevel: String? {
        get { defaults.string(forKey: AppConstants.UserDefaultsKeys.userLevel) }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.userLevel) }
    }
    
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: AppConstants.UserDefaultsKeys.isLoggedIn) }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.isLoggedIn) }
    }
    
    var needsProfileCompletion: Bool {
        get { defaults.bool(forKey: AppConstants.UserDefaultsKeys.needsProfileCompletion) }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.needsProfileCompletion) }
    }
}
