//
//  VoiceEvaluatingView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoiceEvaluatingView: View {
    var body: some View {
        SharedEvaluatingView(
            videoAsset: .speakingLabEvaluating,
            title: L10n.SpeakingLab.evaluatingTitle,
            subtitle: L10n.SpeakingLab.evaluatingSubtitle
        )
    }
}
