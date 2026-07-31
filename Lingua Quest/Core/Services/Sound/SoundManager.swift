//
//  SoundManager.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 30/07/2026.
//

import AVFoundation
import Foundation

final class SoundManager: AppSoundPlayer {
    
    private var players: [AppSound: AVAudioPlayer] = [:]
    private let userPreferences: UserPreferencesProtocol
    
    init(userPreferences: UserPreferencesProtocol) {
        self.userPreferences = userPreferences
        setupAudioSession()
        preloadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
    }
    
    private func preloadSounds() {
        for sound in AppSound.allCases {
            guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
                print("Could not find sound file: \(sound.rawValue).mp3")
                continue
            }
            
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.volume = sound.volume
                players[sound] = player
            } catch {
                print("Failed to load sound file \(sound.rawValue).mp3: \(error)")
            }
        }
    }
    
    func play(sound: AppSound) {
        guard userPreferences.isSoundEnabled else { return }
        
        if let player = players[sound] {
            if player.isPlaying {
                player.currentTime = 0
            } else {
                player.play()
            }
        }
    }
}
