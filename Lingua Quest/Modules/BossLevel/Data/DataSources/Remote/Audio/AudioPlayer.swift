//
//  AudioPlayer.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation
import AVFoundation

final class AudioPlayer: NSObject, AVSpeechSynthesizerDelegate {
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var audioFormat: AVAudioFormat?
    private var isPlaying = false
    private var timer: Timer?
    
    var onAudioLevelChanged: ((Float) -> Void)?
    var onPlaybackFinished: (() -> Void)?
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
        setupEngine()
    }
    
    private func setupEngine() {
        audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: 24000.0,
            channels: 1,
            interleaved: true
        )
        
        if audioFormat == nil || audioFormat?.sampleRate == 0 {
            audioFormat = AVAudioFormat(standardFormatWithSampleRate: 24000.0, channels: 1)
        }
        
        audioEngine.attach(playerNode)
        if let format = audioFormat, format.sampleRate > 0, format.channelCount > 0 {
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: format)
        } else {
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
        }
    }
    
    func speakText(_ text: String, language: String = "en-US") {
        stop()
        // AVAudioSession is managed by BossLevelRepositoryImpl — no need to reconfigure here.
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.95
        utterance.pitchMultiplier = 1.05
        
        speechSynthesizer.speak(utterance)
        startVisualizerPulse()
    }
    
    func playChunk(_ data: Data) {
        guard let format = audioFormat, format.sampleRate > 0, format.channelCount > 0 else { return }
        
        let frameCount = UInt32(data.count / 2)
        guard frameCount > 0, let pcmBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        pcmBuffer.frameLength = frameCount
        
        data.withUnsafeBytes { rawBufferPointer in
            if let address = rawBufferPointer.baseAddress, let channelData = pcmBuffer.int16ChannelData?[0] {
                memcpy(channelData, address, data.count)
            }
        }
        
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
            } catch {
                print("🚀 AudioPlayer start error: \(error)")
                return
            }
        }
        
        if !isPlaying {
            playerNode.play()
            isPlaying = true
        }
        
        playerNode.scheduleBuffer(pcmBuffer)
        
        let level = calculateAudioLevel(data: data)
        onAudioLevelChanged?(level)
    }
    
    func stop() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        playerNode.stop()
        audioEngine.stop()
        isPlaying = false
        stopVisualizerPulse()
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isPlaying = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying = false
        stopVisualizerPulse()
        onAudioLevelChanged?(0.0)
        onPlaybackFinished?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isPlaying = false
        stopVisualizerPulse()
        onAudioLevelChanged?(0.0)
    }
    
    private func startVisualizerPulse() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying || self.speechSynthesizer.isSpeaking else { return }
            let randomLevel = Float.random(in: 0.35...0.85)
            self.onAudioLevelChanged?(randomLevel)
        }
    }
    
    private func stopVisualizerPulse() {
        timer?.invalidate()
        timer = nil
    }
    
    private func calculateAudioLevel(data: Data) -> Float {
        let count = data.count / 2
        guard count > 0 else { return 0.0 }
        var sum: Float = 0
        data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            let int16Pointer = pointer.bindMemory(to: Int16.self)
            for i in 0..<count {
                let sample = Float(int16Pointer[i]) / 32768.0
                sum += sample * sample
            }
        }
        let rms = sqrt(sum / Float(count))
        return min(max(rms * 4.0, 0.0), 1.0)
    }
}
