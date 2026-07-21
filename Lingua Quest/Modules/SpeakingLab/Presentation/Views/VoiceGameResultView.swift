//
//  VoiceGameResultView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoiceGameResultView: View {
    @State var viewModel: VoiceGameResultViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                Group {
                    switch viewModel.state {
                    case .evaluating:
                        VoiceEvaluatingView()
                            .padding(.top, 100)
                    case .success:
                        VoiceSuccessView(viewModel: viewModel)
                    case .failure:
                        VoiceFailureView(viewModel: viewModel)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                .animation(.spring(response: 0.55, dampingFraction: 0.82), value: viewModel.state)
            }
            
            if viewModel.state == .success {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .zIndex(100)
            }
        }
        .navigationBarHidden(true)
    }
}
