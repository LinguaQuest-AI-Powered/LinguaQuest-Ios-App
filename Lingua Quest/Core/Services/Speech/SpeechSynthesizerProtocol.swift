//
//  SpeechSynthesizerProtocol.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

protocol SpeechSynthesizerProtocol: AnyObject {
    var onFinishSpeaking: (() -> Void)? { get set }
    func speak(text: String, languageCode: String)
    func stop()
}
