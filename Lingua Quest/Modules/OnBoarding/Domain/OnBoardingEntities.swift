//
//  OnBoardingEntities.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation

enum OnboardingStep {
    case welcome
    case language
    case level
}

struct Language: Identifiable, Equatable {
    let id = UUID()
    let code: String
    let name: String
    let flag: String
}

extension Language {
    static var allGlobalLanguages: [Language] {
        var uniqueLanguages = [String: Language]()
        let locale = Locale.current
        
        for identifier in Locale.availableIdentifiers {
            let identifierLocale = Locale(identifier: identifier)
            guard let languageCode = identifierLocale.languageCode,
                  let regionCode = identifierLocale.regionCode,
                  let languageName = locale.localizedString(forLanguageCode: languageCode) else {
                continue
            }
            
            // Only add the first region encountered for each language
            if uniqueLanguages[languageCode] == nil {
                let flag = flagEmoji(for: regionCode)
                uniqueLanguages[languageCode] = Language(code: languageCode, name: languageName.capitalized, flag: flag)
            }
        }
        
        return uniqueLanguages.values.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
    
    private static func flagEmoji(for regionCode: String) -> String {
        let base: UInt32 = 127397
        var flagString = ""
        for scalar in regionCode.uppercased().unicodeScalars {
            guard let scalarValue = UnicodeScalar(base + scalar.value) else { continue }
            flagString.unicodeScalars.append(scalarValue)
        }
        return flagString
    }
}

enum UserLevel: String, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner: return L10n.Onboarding.beginnerTitle
        case .intermediate: return L10n.Onboarding.intermediateTitle
        case .advanced: return L10n.Onboarding.advancedTitle
        }
    }

    var subtitle: String {
        switch self {
        case .beginner: return L10n.Onboarding.beginnerDescription
        case .intermediate: return L10n.Onboarding.intermediateDescription
        case .advanced: return L10n.Onboarding.advancedDescription
        }
    }
}
