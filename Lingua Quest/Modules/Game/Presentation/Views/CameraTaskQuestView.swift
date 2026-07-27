//
//  CameraTaskQuestView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.


import SwiftUI

struct CameraTaskQuestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showHintSheet: Bool = false
    @State private var showHintBubble: Bool = false
    @State private var appliedHint: String? = nil
    @State private var showNotEnoughCoinsDialog = false
    @State private var showSkipDialog = false
    @State var viewModel: CameraTaskQuestViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
       
                HStack {
                    CustomBackButton(action: { dismiss() })

                    Spacer()

                    // Coin Counter
                    RewardBadge(type: .coin, value: "\(viewModel.coins)", size: .small)
                }
                .overlay(
                    Text(L10n.Game.levelTitle(viewModel.levelOrder))
                        .appTextStyle(.headingLarge, color: .appTextHeading)
                )
                .padding(.horizontal, 20)
                .frame(height: 64)
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.appBorderBrown),
                    alignment: .bottom
                )

                
                Spacer()
                
                // Card Container
                DialogCardContainer(
                    mascotImage: .loginBird,
                    speechBubbleText: {
                        if let hint = viewModel.hintText {
                            return hint
                        } else if showHintBubble {
                            return L10n.Game.tapForHelp
                        } else {
                            return nil
                        }
                    }(),
                    onMascotTap: {
                        showHintSheet = true
                    }
                ) {
                    VStack(spacing: 24) {
                        // Target Word & Audio Button
                        HStack(spacing: 16) {
                            Text(viewModel.targetWord)
                                .appTextStyle(.displayLarge, color: .appTextSecondary)
                                .minimumScaleFactor(0.4)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .background(Color.appSurfaceCard)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.orange, lineWidth: 2)
                                )
                                .shadow(color: Color.orange.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            Button(action: {
                                // Play audio action
                            }) {
                                Image(systemIcon: .speakerWave2Fill)
                                    .appTextStyle(.headingMediumBold, color: .appTextSecondary)
                                    .frame(width: 56, height: 56)
                                    .background(Color.appSurfaceCard)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                        }
                        
                        // Instructions
                        Text(L10n.Game.scanInstruction(viewModel.targetWord.lowercased()))
                            .appTextStyle(.bodyMedium, color: .gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                        
                        VStack(spacing: 16) {
                            // Primary Camera Button
                            CustomButton(
                                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                                text: L10n.Game.openCamera,
                                action: {
                                    // 1. Trigger the camera scanner here
                                    viewModel.openCamera()
                                },
                                leading: Image(systemIcon: .cameraFill)
                            )
                            
                            // Change Word Button
                            OutlineButton(
                                text: L10n.Game.changeWord,
                                action: { showSkipDialog = true}
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Automatically show the tap for help bubble after 0.2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if !showHintBubble && viewModel.hintText == nil {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showHintBubble = true
                    }
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(L10n.Common.error),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text(L10n.Common.ok))
            )
        }
        .customBottomSheet(isPresented: $showHintSheet, initialDetent: .custom(ratio: 0.52)) {
            GameHintSheet(
                coins: viewModel.coins,
                onClose: { showHintSheet = false },
                onSelectHint: { _ in
                    showHintSheet = false
                    viewModel.onHintSelected()
                },
                onNotEnoughCoins: {
                    showHintSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showNotEnoughCoinsDialog = true
                    }
                }
            )
        }
        .appDialog(isPresented: $showNotEnoughCoinsDialog) {
            NotEnoughCoinsDialog(
                title: L10n.Game.notEnoughCoinsTitle,
                subtitle: L10n.Game.notEnoughCoinsSubtitle,
                missingCoins: AppConstants.Common.changeWordCost
            ) {
                showNotEnoughCoinsDialog = false
                // Handle get more coins (e.g. navigate to store)
            }
        }
        .appDialog(isPresented: $showSkipDialog) {
            CostActionDialog(
                title: L10n.Game.skipWordTitle,
                subtitle: L10n.Game.skipWordSubtitle(AppConstants.Common.changeWordCost),
                cost: AppConstants.Common.changeWordCost,
                mascotImage: .skip,
                primaryButtonText: L10n.Game.changeWord,
                primaryButtonIcon: .arrowTriangle2Circlepath,
                primaryAction: {
                    showSkipDialog = false
                    if viewModel.coins >= AppConstants.Common.changeWordCost {
                        viewModel.onChangeWordTapped()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showNotEnoughCoinsDialog = true
                        }
                    }
                },
                cancelAction: {
                    showSkipDialog = false
                }
            )
        }
    }
}

class MockStatsService: StatsServiceProtocol {
    var coins: Int = 1250
    var xp: Int = 100
    var streakDays: Int = 5
    func fetchStats() async throws {}
    func addCoins(_ amount: Int) async throws {}
    func deductCoins(_ amount: Int) async throws {}
    func addXP(_ amount: Int) async throws {}
    func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws {}
    func syncBalances(coins: Int, xp: Int, streakDays: Int?) {}
    func resetAll() {}
}

#Preview("LightTheme") {
    // Requires Mock dependencies for previews
    // CameraTaskQuestView(viewModel: CameraTaskQuestViewModel(...))
    Text("Preview temporarily disabled due to complex dependencies")
}

#Preview("DarkTheme") {
    // CameraTaskQuestView(viewModel: CameraTaskQuestViewModel(...))
    Text("Preview temporarily disabled due to complex dependencies")
        .preferredColorScheme(.dark)
}


