//
//  LeaderboardHeaderView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import SwiftUI

struct LeaderboardHeaderView: View {
    @State private var viewModel : LeaderboardViewModel
    
    init(viewModel: LeaderboardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            CustomBackButton(action: {
                viewModel.backToProfile()
            })
            
            Spacer()
        }
        .overlay(
            Text(L10n.Leaderboard.title)
                .appTextStyle(.headingLarge, color: .appTextHeading)
        )
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(Color.clear)

    }
}

