//
//  LeaderboardView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import SwiftUI

struct LeaderboardView: View {
    @State var viewModel: LeaderboardViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
            LeaderboardHeaderView(
                viewModel: viewModel,
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    LeaderboardPodiumView(topUsers: viewModel.topUsers)
                    
                    LeaderboardListView(users: viewModel.otherUsers)
                }
            }
                }
            }
        
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}



