//
//  MindReaderTargetTranslator.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 07/08/2026.
//

import Foundation

struct MindReaderTargetTranslator {
    
    /// Translates an AnswerState to the provided target language.
    /// Falls back to English if the language is not in the supported list of 10 languages.
    static func translate(answer: AnswerState, targetLanguage: String) -> String {
        let lang = targetLanguage.lowercased()
        
        switch answer {
        case .yes:
            return yesTranslations[lang] ?? yesTranslations["english"]!
        case .no:
            return noTranslations[lang] ?? noTranslations["english"]!
        case .sometimes:
            return sometimesTranslations[lang] ?? sometimesTranslations["english"]!
        case .probablyNot:
            return probablyNotTranslations[lang] ?? probablyNotTranslations["english"]!
        case .unknown:
            return unknownTranslations[lang] ?? unknownTranslations["english"]!
        }
    }
    
    private static let yesTranslations: [String: String] = [
        "english": "Yes",
        "arabic": "نعم",
        "spanish": "Sí",
        "french": "Oui",
        "german": "Ja",
        "italian": "Sì",
        "portuguese": "Sim",
        "japanese": "はい",
        "korean": "네",
        "chinese": "是的"
    ]
    
    private static let noTranslations: [String: String] = [
        "english": "No",
        "arabic": "لا",
        "spanish": "No",
        "french": "Non",
        "german": "Nein",
        "italian": "No",
        "portuguese": "Não",
        "japanese": "いいえ",
        "korean": "아니요",
        "chinese": "不是"
    ]
    
    private static let sometimesTranslations: [String: String] = [
        "english": "Sometimes",
        "arabic": "أحياناً",
        "spanish": "A veces",
        "french": "Parfois",
        "german": "Manchmal",
        "italian": "A volte",
        "portuguese": "Às vezes",
        "japanese": "時々",
        "korean": "가끔",
        "chinese": "有时候"
    ]
    
    private static let probablyNotTranslations: [String: String] = [
        "english": "Probably Not",
        "arabic": "على الأرجح لا",
        "spanish": "Probablemente no",
        "french": "Probablement pas",
        "german": "Wahrscheinlich nicht",
        "italian": "Probabilmente no",
        "portuguese": "Provavelmente não",
        "japanese": "たぶん違う",
        "korean": "아마 아닐 거예요",
        "chinese": "可能不是"
    ]
    
    private static let unknownTranslations: [String: String] = [
        "english": "I Don't Know",
        "arabic": "لا أعرف",
        "spanish": "No lo sé",
        "french": "Je ne sais pas",
        "german": "Ich weiß nicht",
        "italian": "Non lo so",
        "portuguese": "Não sei",
        "japanese": "わからない",
        "korean": "모르겠어요",
        "chinese": "我不知道"
    ]
}
