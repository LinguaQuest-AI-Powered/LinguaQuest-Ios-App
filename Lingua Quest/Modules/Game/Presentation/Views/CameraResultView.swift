//
//  CameraResultView.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import SwiftUI

struct CameraResultView: View {
    @State var viewModel: CameraResultViewModel
    @State private var isAnalyzingPulsing = false
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            Group {
                switch viewModel.state {
                case .loading:
                    loadingView
                case .success:
                    successView
                case .failure:
                    failureView
                }
            }
            .animation(.spring(response: 0.55, dampingFraction: 0.82), value: viewModel.state)
        }
        .navigationBarHidden(true)
    }
    
    private var loadingView: some View {
        DialogCardContainer(showMascot: false) {
            VStack(spacing: 28) {
                // Video container with shadow and circular frame - larger size
                ZStack {
                    Circle()
                        .fill(Color(red: 254/255, green: 254/255, blue: 254/255))
                        .frame(width: 250, height: 250)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                    
                    LoopedVideoPlayerView(videoAsset: .loading)
                        .frame(width: 230, height: 230)
                        .clipShape(Circle())
                }
                
                VStack(spacing: 12) {
                    Text(L10n.Game.analyzing)
                        .appTextStyle(.displayMedium, color: .appBrandBrown)
                        .scaleEffect(isAnalyzingPulsing ? 1.05 : 0.95)
                        .opacity(isAnalyzingPulsing ? 1.0 : 0.7)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnalyzingPulsing)
                    
                    Text(L10n.Game.analyzingSubtitle)
                        .appTextStyle(.body, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
        .onAppear {
            isAnalyzingPulsing = true
        }
    }
    
    private var failureView: some View {
        DialogCardContainer(mascotImage: .bird) {
            VStack(spacing: 24) {
                    Text(L10n.Game.notQuite)
                        .appTextStyle(.displayMedium, color: .appBrandBrown)
                    
                    Text(L10n.Game.didntSeeItem(viewModel.targetWord.lowercased()))
                        .appTextStyle(.body, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                    
                    Button(action: {
                        // Hint action
                    }) {
                        HStack {
                            Image(systemIcon: .lightbulbFill)
                            Text(L10n.Game.makeSureLit)
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.appBrandBrown)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.appAccentGold.opacity(0.2))
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.appAccentGold.opacity(0.5), lineWidth: 1)
                        )
                    }
                    
                    VStack(spacing: 16) {
                        CustomButton(
                            type: .primary,
                            text: L10n.Game.retryCamera,
                            action: viewModel.onRetryTapped,
                            leading: Image(systemIcon: .arrowLeft) // We don't have a retry icon, using left arrow or custom
                        )
                        
                        CustomButton(
                            type: .secendry,
                            text: L10n.Game.changeWord,
                            action: viewModel.onChangeWordTapped
                        )
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 24)
            .transition(.scale.combined(with: .opacity))
        }
        
        private var successView: some View {
            DialogCardContainer(mascotImage: .perfect) {
                VStack(spacing: 24) {
                    Text(L10n.Game.perfect)
                        .appTextStyle(.displayMedium, color: .appBrandBrown)
                    
                    Text(L10n.Game.youFoundIt)
                        .appTextStyle(.body, color: .appTextSecondary)
                    
                    // Rewards Pills
                    HStack(spacing: 16) {
                        RewardBadge(type: .xp, value: L10n.Game.xpPoints(viewModel.xpPoints), size: .large)
                        RewardBadge(type: .coin, value: L10n.Game.coinsValue(viewModel.coinsEarned), size: .large)
                    }
                    
                    // Progress
                    VStack(spacing: 8) {
                        HStack {
                            Text(L10n.Game.levelProgress(viewModel.currentLevelIndex))
                                .appTextStyle(.captionBold, color: .appBrandBrown)
                            Spacer()
                            Text("\(Int(viewModel.currentLevelProgress * 100))%")
                                .appTextStyle(.captionBold, color: .appBrandBrown)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 12)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.appAccentOrange)
                                    .frame(width: geometry.size.width * CGFloat(viewModel.currentLevelProgress), height: 12)
                            }
                        }
                        .frame(height: 12)
                    }
                    .padding(.vertical, 8)
                    
                    CustomButton(
                        type: .primary,
                        text: L10n.Game.nextLevel,
                        action: viewModel.onNextLevelTapped
                    )
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 24)
            .transition(.scale.combined(with: .opacity))
        }
    }

