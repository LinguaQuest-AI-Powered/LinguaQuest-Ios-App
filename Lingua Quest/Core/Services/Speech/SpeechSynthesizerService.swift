//
//  SpeechSynthesizerService.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import AVFoundation

final class AVSpeechSynthesizerService: NSObject, SpeechSynthesizerProtocol {
    // MARK: - Properties
    private let synthesizer = AVSpeechSynthesizer()
    var onFinishSpeaking: (() -> Void)?
    
    // MARK: - Init
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    // MARK: - API
    func speak(text: String, languageCode: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session for speech: \(error)")
        }
        
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode.toSpeechLanguageCode())
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension AVSpeechSynthesizerService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in self?.onFinishSpeaking?() }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in self?.onFinishSpeaking?() }
    }
}
