//
//  MindReaderEndpoints.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct MindReaderPayload: Encodable {
    let modelId: String
    let messages: [[String: String]]
    
    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case messages
    }
}

struct MindReaderNextStepEndpoint: AIEndpoint {
    let categoryContext: String
    let historyPrompt: String
    let targetLanguage: String
    let nativeLanguage: String
    
    var path: String {
        return "/chat"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var body: MindReaderPayload? {
        let maxTurns = GameRules.maxTurns
        
        let promptText = """
        You are the engine behind "Lingo's Mind Reader", an Akinator-style guessing game for language learners. The user is thinking of ONE specific word that belongs to this category:

        Category context: "\(categoryContext)"

        Conversation so far (question asked in the target language, and the user's answer):
        \(historyPrompt)

        (If historyPrompt is empty, this is the very first question.)

        Your job: decide the SINGLE best next yes/no-style question to narrow down the word, the same way a human playing 20-questions would — pick the question that splits the remaining possibilities roughly in half. Never repeat a question already asked. If (and only if) you are reasonably confident after the conversation so far (or if the conversation has \(maxTurns) or more turns), STOP asking and make your best guess instead.

        Target language: \(targetLanguage)
        Native language: \(nativeLanguage)

        CRITICAL RULE 1: If asking a question, "questionTargetText" MUST be written ONLY in \(targetLanguage), and "questionNativeText" MUST be its accurate translation in \(nativeLanguage).
        CRITICAL RULE 2: Only set type to "guess" when you are actually naming a specific concrete word/object, never a category or vague guess.
        CRITICAL RULE 3: The guessed word must plausibly belong to the given category context.

        Respond STRICTLY in the following JSON format (no markdown, no backticks, just raw JSON):
        {
          "type": "question" | "guess",
          "questionTargetText": "<string or null>",
          "questionNativeText": "<string or null>",
          "guessWord": "<string or null, in target language>",
          "guessTranslation": "<string or null, in native language>",
          "guessEmoji": "<single system emoji representing the word, or null>"
        }
        """
        
        return MindReaderPayload(
            modelId: "deepseek.v3.2",
            messages: [
                ["role": "user", "content": promptText]
            ]
        )
    }
}

struct MindReaderQuizEndpoint: AIEndpoint {
    let categoryContext: String
    let correctWord: String
    let nativeLanguage: String
    let targetLanguage: String
    
    var path: String {
        return "/chat"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var body: MindReaderPayload? {
        let promptText = """
        The user just correctly identified the word "\(correctWord)" (in \(targetLanguage)) from this category: "\(categoryContext)".

        Generate exactly 3 answer options for a translation quiz in \(nativeLanguage): one is the correct translation of "\(correctWord)", and two are plausible-but-wrong translations of OTHER words from the same category (similar difficulty, not obviously wrong). Shuffle the order.

        CRITICAL RULE: Exactly one option must have "isCorrect": true.

        Respond STRICTLY in the following JSON format (no markdown, no backticks):
        {
          "choices": [
            {"translationText": "<string>", "isCorrect": true|false},
            {"translationText": "<string>", "isCorrect": true|false},
            {"translationText": "<string>", "isCorrect": true|false}
          ]
        }
        """
        
        return MindReaderPayload(
            modelId: "deepseek.v3.2",
            messages: [
                ["role": "user", "content": promptText]
            ]
        )
    }
}

struct MindReaderHonestyEndpoint: AIEndpoint {
    let categoryContext: String
    let historyPrompt: String
    let claimedWord: String
    let feedbackLanguage: String
    
    var path: String {
        return "/chat"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var body: MindReaderPayload? {
        let promptText = """
        The user played a guessing game and, when the AI failed to guess, claimed they were thinking of the word "\(claimedWord)" (category: "\(categoryContext)").

        Here is the full history of questions asked and the user's answers:
        \(historyPrompt)

        Check whether "\(claimedWord)" is logically consistent with EVERY answer the user gave. A real-world word/object should reasonably match yes/no/sometimes answers about its typical properties. If there is a clear contradiction (e.g. user said "no" to a property that is obviously true for "\(claimedWord)", or vice versa), the user was not honest.

        CRITICAL RULE 1: Be reasonably lenient — "sometimes" and "probably not" allow for ambiguity, only flag CLEAR contradictions, not borderline cases.
        CRITICAL RULE 2: "explanation" MUST be written in \(feedbackLanguage), must be short (max 2 sentences), friendly if honest, and clearly point out the contradiction if not honest.

        Respond STRICTLY in the following JSON format (no markdown, no backticks):
        {
          "isHonest": true|false,
          "explanation": "<short message in \(feedbackLanguage)>"
        }
        """
        
        return MindReaderPayload(
            modelId: "deepseek.v3.2",
            messages: [
                ["role": "user", "content": promptText]
            ]
        )
    }
}
