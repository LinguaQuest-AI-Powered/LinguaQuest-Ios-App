

import SwiftUI
import UIKit

struct BossLevelView: View {
    @State private var viewModel: BossLevelViewModel
    @State private var showFinishDialog: Bool = false

    init(viewModel: BossLevelViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()

            switch viewModel.viewState {
            case .loading:
                ProgressView(L10n.Common.loading)

            case .result(let result):
                BossResultView(result: result, onCloseTapped: { viewModel.onCloseTapped() })

            case .evaluating:
                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(2.0)
                    Text(L10n.BossLevel.evaluating)
                        .appTextStyle(.headingMedium, color: .appTextHeading)
                }

            case .lobby(let scenario):
                VStack(spacing: 0) {
                    headerBar(onBack: { viewModel.onCloseTapped() })
                        .padding(.top, 8)
                    Spacer()
                    lobbyContent(scenario: scenario)
                    Spacer()
                }

            case .active:
                VStack(spacing: 0) {
                    headerBar(onBack: { showFinishDialog = true })
                        .padding(.top, 8)
                    Spacer()
                    activeSessionContent
                    Spacer()
                    BossLevelControlsView(
                        isHoldingMic: viewModel.isHoldingMic,
                        isAISpeaking: viewModel.sessionState.isAISpeaking,
                        onMicPress: { viewModel.startSpeaking() },
                        onMicRelease: { viewModel.stopSpeaking() },
                        onEndCall: { showFinishDialog = true }
                    )
                }

            case .error:
                VStack(spacing: 16) {
                    Text(L10n.Common.errorOccurred)
                        .appTextStyle(.body, color: .appTextSecondary)
                    CustomButton(type: .secendry, text: L10n.Common.goBack, action: { viewModel.onCloseTapped() }, status: .enable)
                        .frame(width: 140)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .appDialog(isPresented: $showFinishDialog) {
            finishConfirmationDialogContent
        }
        .alert(
            isMicError ? L10n.BossLevel.statusError : L10n.Common.error,
            isPresented: Binding(
                get: { if case .error = viewModel.viewState { return true }; return false },
                set: { _ in }
            )
        ) {
            if isMicError {
                Button(L10n.Common.openSettings) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            Button(L10n.Common.ok, role: .cancel) {
                viewModel.onCloseTapped()
            }
        } message: {
            if case .error(let msg) = viewModel.viewState {
                Text(msg)
            }
        }
    }

    private var isMicError: Bool {
        if case .error(let msg) = viewModel.viewState {
            let lower = msg.lowercased()
            return lower.contains("microphone") || lower.contains("permission") || lower.contains("audio")
        }
        return false
    }

    // MARK: - Header Bar

    private func headerBar(onBack: @escaping () -> Void) -> some View {
        ZStack {
            Text(L10n.BossLevel.title)
                .appTextStyle(.headingMediumBold, color: .appTextHeading)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                CustomBackButton(action: onBack)
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
    }

    private var languagePill: some View {
        HStack(spacing: 6) {
            Text("🌐")
                .font(.system(size: 14))
            Text(Locale.current.language.languageCode?.identifier == "ar" ? "العربية" : "English")
                .appTextStyle(.captionMedium, color: .appTextHeading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.appSurfaceCard)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private var activeObjective: some View {
        VStack(spacing: 8) {
            if let objective = viewModel.scenario?.objective {
                Text(L10n.BossLevel.objectivePrefix(objective))
                    .appTextStyle(.body, color: .white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text(viewModel.formattedTimeRemaining)
                .appTextStyle(.headingLarge, color: .white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.appBossBanner)
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }

    // MARK: - Lobby Content (Image 3)

    private func lobbyContent(scenario: BossScenario) -> some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .bird3,
            customMascotSize: CGSize(width: 180, height: 180)
        ) {
            VStack(spacing: 16) {
                Text(L10n.BossLevel.phase)
                    .appTextStyle(.headingLarge, color: .appAccentOrange)

                VStack(spacing: 8) {
                    Text(L10n.BossLevel.meetBoss(scenario.bossName))
                        .appTextStyle(.headingMediumBold, color: .appTextHeading)

                    Text(scenario.roleDescription)
                        .appTextStyle(.caption, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                }

                // Goal Box
                VStack(spacing: 12) {
                    Text(L10n.BossLevel.yourObjective)
                        .appTextStyle(.headingMedium, color: .appAccentOrange)

                    Text(scenario.objective)
                        .appTextStyle(.bodyLargeBold, color: .appTextHeading)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(L10n.BossLevel.readCarefully)
                        .appTextStyle(.microSemibold, color: .appTextSecondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color.appBackgroundWarm.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appAccentOrange.opacity(0.8), lineWidth: 1.5)
                )
                .cornerRadius(16)
                .padding(.top, 8)

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

    // MARK: - Active Session Content (Image 4)

    private var activeSessionContent: some View {
        VStack(spacing: 16) {
            activeObjective

            Image(asset: .micBird)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .scaleEffect(viewModel.sessionState.isAISpeaking ? 1.06 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: viewModel.sessionState.isAISpeaking)

            BossLevelTranscriptView(
                messages: viewModel.messages,
                onTapToTalk: { }
            )

            Spacer(minLength: 10)
        }
    }

    // MARK: - Finish Stage Dialog Content (Image 5)

    private var finishConfirmationDialogContent: some View {
        DialogCardContainer(showMascot: false) {
            VStack(spacing: 20) {
                Text(L10n.BossLevel.finishStageTitle)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
                    .multilineTextAlignment(.center)

                Text(L10n.BossLevel.finishStageSubtitle)
                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    CustomButton(
                        type: .custom(textColor: .appTextHeading, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
                        text: L10n.BossLevel.yesEvaluate,
                        action: {
                            showFinishDialog = false
                            viewModel.endChallenge()
                        },
                        status: .enable
                    )

                    CustomButton(
                        type: .secendry,
                        text: L10n.BossLevel.keepTalking,
                        action: { showFinishDialog = false },
                        status: .enable
                    )
                }
            }
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 24)
    }
}
