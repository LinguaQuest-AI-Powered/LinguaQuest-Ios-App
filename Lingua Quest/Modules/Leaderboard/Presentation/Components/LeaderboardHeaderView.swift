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
            
            Text(L10n.Leaderboard.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.appPodiumBrownText)
            
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.appLeaderboardBackground) 
    }
}

