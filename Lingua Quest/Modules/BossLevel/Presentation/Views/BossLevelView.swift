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

            VStack(spacing: 0) {
                headerBar
                    .padding(.top, 8)

                Spacer()

                if viewModel.isSessionStarted {
                    activeSessionContent
                } else {
                    initialContent
                }

                Spacer()

                bottomActionButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .alert("Microphone Access Required",
               isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
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

    // MARK: - Initial content (before session starts)

    private var initialContent: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .stroke(Color.appBrandPrimary.opacity(0.7), lineWidth: 3)
                    .frame(width: 164, height: 164)
                Circle()
                    .fill(Color.appSurfaceCard)
                    .frame(width: 154, height: 154)
                Image(systemName: "bird.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color.appBrandBrownDark)
            }

            Text(viewModel.descriptionText)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.appTextSlate)
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
        }
    }

    // MARK: - Active session content

    private var activeSessionContent: some View {
        VStack(spacing: 24) {
            BossLevelVisualizerView(
                isAISpeaking: viewModel.state.isAISpeaking,
                isUserSpeaking: viewModel.state.isUserSpeaking,
                aiAudioLevel: viewModel.state.aiAudioLevel,
                userAudioLevel: viewModel.state.userAudioLevel
            )

            BossLevelTranscriptView(
                messages: viewModel.messages,
                onTapToTalk: { /* tap-to-talk replaced by hold gesture */ }
            )
            .frame(maxHeight: 220)
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Bottom action area

    private var bottomActionButton: some View {
        Group {
            if viewModel.isSessionStarted {
                BossLevelControlsView(
                    isHoldingMic: viewModel.isHoldingMic,
                    isAISpeaking: viewModel.state.isAISpeaking,
                    onMicPress: { viewModel.startSpeaking() },
                    onMicRelease: { viewModel.stopSpeaking() },
                    onEndCall: { viewModel.endChallenge() }
                )
            } else {
                CustomButton(
                    type: .primary,
                    text: "Start Challenge",
                    action: { viewModel.startChallenge() },
                    status: .enable
                )
            }
        }
    }
}
