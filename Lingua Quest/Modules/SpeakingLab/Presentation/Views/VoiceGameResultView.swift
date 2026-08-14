//
//  VoiceGameResultView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoiceGameResultView: View {
    @State var viewModel: VoiceGameResultViewModel
    @State private var coinBadgeCenter: CGPoint = .zero
    @State private var coinCardCenter: CGPoint = .zero
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    CustomBackButton(action: { viewModel.onReturnHome() })
                    
                    Spacer()
                    
                    // Coin Counter
                    RewardBadge(type: .coin, value: viewModel.coins.formattedStatsValue(), size: .small)
                        .background(GeometryReader { geo in
                            Color.clear.onAppear {
                                let frame = geo.frame(in: .named("global"))
                                DispatchQueue.main.async {
                                    self.coinBadgeCenter = CGPoint(x: frame.midX, y: frame.midY)
                                }
                            }
                        })
                }
                .overlay(
                    Text(L10n.SpeakingLab.voicePractice)
                        .appTextStyle(.headingLarge, color: .appTextHeading)
                )
                .padding(.horizontal, 20)
                .frame(height: 64)
                
                ScrollView(showsIndicators: false) {
                    Group {
                        switch viewModel.state {
                        case .evaluating:
                            VoiceEvaluatingView()
                                .padding(.top, 40)
                        case .success:
                            VoiceSuccessView(viewModel: viewModel, coinCardCenter: $coinCardCenter)
                        case .failure:
                            VoiceFailureView(viewModel: viewModel)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.55, dampingFraction: 0.82), value: viewModel.state)
                }
            }
            
            if viewModel.state == .success {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .zIndex(100)
                
                if coinCardCenter != .zero && coinBadgeCenter != .zero {
                    CoinFlyAnimationView(startPoint: coinCardCenter, endPoint: coinBadgeCenter)
                        .zIndex(101)
                }
            }
        }
        .coordinateSpace(name: "global")
        .navigationBarHidden(true)
        .aiUnavailableDialog(isPresented: Bindable(viewModel).showAiUnavailableDialog)
    }
}
