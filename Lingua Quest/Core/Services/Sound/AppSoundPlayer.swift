//
//  AppSoundPlayer.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 30/07/2026.
//

import SwiftUI

protocol AppSoundPlayer: AnyObject {
    func play(sound: AppSound)
}

private struct SoundPlayerKey: EnvironmentKey {
    // Provide a dummy default implementation so it doesn't crash if not injected,
    // though we will inject it at RootView.
    static let defaultValue: AppSoundPlayer = DummySoundPlayer()
}

extension EnvironmentValues {
    var soundPlayer: AppSoundPlayer {
        get { self[SoundPlayerKey.self] }
        set { self[SoundPlayerKey.self] = newValue }
    }
}

private class DummySoundPlayer: AppSoundPlayer {
    func play(sound: AppSound) {
        // Do nothing by default
    }
}
