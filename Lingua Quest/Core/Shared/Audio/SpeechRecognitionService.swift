//
//  SpeechRecognitionService.swift
//  Lingua Quest
//
//  Created by siam on 22/07/2026.
//

import Foundation
import Speech

protocol SpeechRecognitionServiceProtocol {
    func transcribeAudio(at url: URL, locale: Locale) async throws -> String
}

class SpeechRecognitionService: SpeechRecognitionServiceProtocol {
    
    func transcribeAudio(at url: URL, locale: Locale) async throws -> String {
        // Request authorization
        let status = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        
        guard status == .authorized else {
            throw NSError(
                domain: "SpeechRecognition",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Speech recognition not authorized"]
            )
        }
        
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else {
            throw NSError(
                domain: "SpeechRecognition",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Speech recognizer not available for locale: \(locale.identifier)"]
            )
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        
        return try await withCheckedThrowingContinuation { continuation in
            recognizer.recognitionTask(with: request) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result, result.isFinal else { return }
                
                let transcription = result.bestTranscription.formattedString
                continuation.resume(returning: transcription)
            }
        }
    }
}
