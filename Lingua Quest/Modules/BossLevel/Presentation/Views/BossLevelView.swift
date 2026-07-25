//
//  BossLevelView.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import SwiftUI
import UIKit

struct BossLevelView: View {
    @State private var viewModel: BossLevelViewModel

    init(viewModel: BossLevelViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()

            switch viewModel.viewState {
            case .loading:
                ProgressView("Loading Scenario...")
            
            case .result(let result):
                BossResultView(result: result, onCloseTapped: { viewModel.onCloseTapped() })
                
            case .evaluating:
                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(2.0)
                    Text("Lingo is evaluating your performance...")
                        .appTextStyle(.headingMedium, color: .appTextHeading)
                }
                
            case .lobby(let scenario):
                VStack(spacing: 0) {
                    headerBar
                        .padding(.top, 8)
                    Spacer()
                    lobbyContent(scenario: scenario)
                    Spacer()
                }
                
            case .active:
                VStack(spacing: 0) {
                    headerBar
                        .padding(.top, 8)
                    Spacer()
                    activeSessionContent
                    Spacer()
                    BossLevelControlsView(
                        isHoldingMic: viewModel.isHoldingMic,
                        isAISpeaking: viewModel.sessionState.isAISpeaking,
                        onMicPress: { viewModel.startSpeaking() },
                        onMicRelease: { viewModel.stopSpeaking() },
                        onEndCall: { viewModel.endChallenge() }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
            case .error:
                VStack {
                    Text("An error occurred.")
                    CustomButton(type: .secendry, text: "Go Back", action: { viewModel.onCloseTapped() }, status: .enable)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .alert(
            isMicError ? "Microphone Access Required" : "Error",
            isPresented: Binding(
                   get: { if case .error = viewModel.viewState { return true }; return false },
                   set: { _ in }
            )
        ) {
            if isMicError {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { viewModel.onCloseTapped() }
            } else {
                Button("OK") { viewModel.onCloseTapped() }
            }
        } message: {
            if case .error(let msg) = viewModel.viewState {
                Text(msg)
            }
        }
    }

    private var isMicError: Bool {
        if case .error(let msg) = viewModel.viewState {
            return msg.lowercased().contains("microphone") || msg.lowercased().contains("permission") || msg.lowercased().contains("audio")
        }
        return false
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            CustomBackButton(action: { viewModel.onCloseTapped() })
            Spacer()
        }
        .overlay(
            Text(L10n.BossLevel.title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(Color.appTextHeading)
        )
        .padding(.horizontal, 24)
        .frame(height: 64)
    }

    // MARK: - Lobby Content

    private func lobbyContent(scenario: BossScenario) -> some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .bird3,
            customMascotSize: CGSize(width: 200, height: 200)
        ) {
            VStack(spacing: 16) {
                Text(L10n.BossLevel.phase)
                    .appTextStyle(.headingLarge, color: .appAccentOrange)
                
                VStack(spacing: 12) {
                    Text(L10n.BossLevel.meetBoss(scenario.bossName))
                        .appTextStyle(.headingMedium, color: .appTextHeading)
                    
                    Text(scenario.roleDescription)
                        .appTextStyle(.caption, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 24)
                }
                
                // Goal Box
                VStack(spacing: 16) {
                    Text(L10n.BossLevel.yourGoal)
                        .appTextStyle(.headingMedium, color: .appAccentOrange)

                    Text(scenario.objective)
                        .appTextStyle(.bodyLargeBold, color: .appTextHeading)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(L10n.BossLevel.readCarefully)
                        .appTextStyle(.micro, color: .appTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(Color.appBackgroundWarm.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appAccentOrange.opacity(0.8), lineWidth: 1.5)
                )
                .cornerRadius(16)
                .padding(.top, 16)
                
                Spacer()
                
                CustomButton(
                    type: .custom(textColor: .appTextHeading, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
                    text: L10n.BossLevel.startRoleplay,
                    action: { viewModel.startChallenge() },
                    status: .enable
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }

    // MARK: - Active session content

    private var activeSessionContent: some View {
        VStack(spacing: 24) {
            BossLevelVisualizerView(
                isAISpeaking: viewModel.sessionState.isAISpeaking,
                isUserSpeaking: viewModel.sessionState.isUserSpeaking,
                aiAudioLevel: viewModel.sessionState.aiAudioLevel,
                userAudioLevel: viewModel.sessionState.userAudioLevel
            )

            BossLevelTranscriptView(
                messages: viewModel.messages,
                onTapToTalk: { /* tap-to-talk replaced by hold gesture */ }
            )
            .frame(maxHeight: 220)
            .padding(.horizontal, 20)
        }
    }
}
