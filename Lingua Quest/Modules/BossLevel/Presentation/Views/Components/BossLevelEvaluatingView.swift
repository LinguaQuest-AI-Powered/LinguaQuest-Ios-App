//
//  BossLevelEveleuationView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 26/07/2026.
//

import SwiftUI

struct BossLevelEvaluatingView: View {
    var body: some View {
        SharedEvaluatingView(
            videoAsset: .speakingLabEvaluating,
            title: L10n.BossLevel.evaluating,
            subtitle: L10n.BossLevel.evaluatingSubtitle
        )
    }
}

#Preview {
    BossLevelEvaluatingView()
}
