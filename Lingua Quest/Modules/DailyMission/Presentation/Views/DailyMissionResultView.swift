//
//  DailyMissionResultView.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import SwiftUI

struct DailyMissionResultView: View {
    @State var viewModel: DailyMissionResultViewModel
    @State private var showAlreadySolvedDialog = false

    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()

            Group {
                switch viewModel.state {
                case .loading:
                    loadingView
                case .match:
                    successView
                case .notMatch:
                    failureView
                case .alreadySolved:
                    alreadySolvedView
                case .error(let message):
                    errorView(message)
                }
            }
            .animation(.spring(response: 0.55, dampingFraction: 0.82), value: viewModel.state)

            if viewModel.state == .match {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .zIndex(100)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Loading

    private var loadingView: some View {
        SharedEvaluatingView(
            videoAsset: .loading,
            title: L10n.DailyMission.analyzing,
            subtitle: L10n.DailyMission.analyzingSubtitle
        )
    }

    // MARK: - Success

    private var successView: some View {
        DialogCardContainer(mascotImage: .perfect) {
            VStack(spacing: 24) {
                Text(L10n.DailyMission.successTitle)
                    .dialogTitleStyle()

                Text(L10n.DailyMission.successSubtitle)
                    .dialogSubtitleStyle()
                    .multilineTextAlignment(.center)

                HStack(spacing: 16) {
                    RewardCardView(
                        type: .xp,
                        title: L10n.DailyMission.rewardXP,
                        amount: viewModel.xpEarned
                    )

                    RewardCardView(
                        type: .coin,
                        title: L10n.DailyMission.rewardCoins,
                        amount: viewModel.coinsEarned
                    )
                }
                .padding(.horizontal, 16)

                CustomButton(
                    type: .primary,
                    text: L10n.DailyMission.backToHome,
                    action: viewModel.onBackToHomeTapped
                )
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Failure

    private var failureView: some View {
        DialogCardContainer(mascotImage: .weakPasswordBird) {
            VStack(spacing: 24) {
                Text(L10n.DailyMission.failTitle)
                    .appTextStyle(.displayMedium, color: .appBrandBrown)

                Text(L10n.DailyMission.failSubtitle(viewModel.targetWord.lowercased()))
                    .appTextStyle(.body, color: .appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                VStack(spacing: 16) {
                    CustomButton(
                        type: .primary,
                        text: L10n.DailyMission.tryAgain,
                        action: viewModel.onRetryTapped,
                        leading: Image(systemIcon: .arrowLeft)
                    )

                    OutlineButton(
                        text: L10n.DailyMission.later,
                        action: viewModel.onLaterTapped
                    )
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Already Solved

    private var alreadySolvedView: some View {
        DialogCardContainer(mascotImage: .perfect) {
            VStack(spacing: 24) {
                Text(L10n.DailyMission.alreadySolvedTitle)
                    .dialogTitleStyle()

                Text(L10n.DailyMission.alreadySolvedSubtitle)
                    .dialogSubtitleStyle()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                CustomButton(
                    type: .primary,
                    text: L10n.DailyMission.backToHome,
                    action: viewModel.onAlreadySolvedDismissed
                )
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        DialogCardContainer(mascotImage: .weakPasswordBird) {
            VStack(spacing: 24) {
                Text(L10n.Common.error)
                    .dialogTitleStyle()

                Text(message)
                    .dialogSubtitleStyle()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                VStack(spacing: 16) {
                    CustomButton(
                        type: .primary,
                        text: L10n.DailyMission.retryButton,
                        action: viewModel.onErrorRetryTapped,
                        leading: Image(systemIcon: .arrowLeft)
                    )

                    OutlineButton(
                        text: L10n.DailyMission.later,
                        action: viewModel.onLaterTapped
                    )
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
    }
}
