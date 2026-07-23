//
//  AudioRecorderService.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import AVFoundation

protocol AudioRecorderServiceProtocol {
    func requestPermissions() async -> Bool
    func startRecording() throws
    func stopRecording() -> Data?
    func getRecordingURL() -> URL?
}

class AudioRecorderService: NSObject, AudioRecorderServiceProtocol, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var fileURL: URL
    
    override init() {
        let tempDir = FileManager.default.temporaryDirectory
        self.fileURL = tempDir.appendingPathComponent("recording.m4a")
        super.init()
    }
    
    func requestPermissions() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func startRecording() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
        try audioSession.setActive(true)
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1, // Mono
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }
    
    func stopRecording() -> Data? {
        audioRecorder?.stop()
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return data
    }
    
    func getRecordingURL() -> URL? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        return fileURL
    }
}
