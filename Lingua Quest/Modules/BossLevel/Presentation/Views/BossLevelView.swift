

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
                LoadingView()

            case .result(let result):
                BossResultView(result: result, coins: viewModel.coins, onCloseTapped: { viewModel.onCloseTapped() })

            case .evaluating:
                BossLevelEvaluatingView()

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
                    activeSessionContent
                        .frame(maxHeight: .infinity)
                    
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
                    CustomButton(type: .primary, text: L10n.Common.goBack, action: { viewModel.onCloseTapped() }, status: .enable)
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

    private var mascotImageForState: Image.Asset {
        if viewModel.isHoldingMic {
            return .micBird
        } else if viewModel.sessionState.isAISpeaking {
            return .resetPasswordBird
        } else {
            return .bird
        }
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
        VStack(spacing: 4) {
            if let objective = viewModel.scenario?.objective {
                Text(L10n.BossLevel.objectivePrefix(objective))
                    .appTextStyle(.bodySemibold, color: .appTextHeading)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text(viewModel.formattedTimeRemaining)
                .appTextStyle(.bodyLargeBold, color: .appTextHeading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .background(
            SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                .fill(Color.appSurfaceCard)
                .shadow(color: Color.appBorderBrown.opacity(0.2), radius: 6, x: 0, y: 3)
        )
        .overlay(
            SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                .stroke(Color.appBorderBrown, lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Lobby Content

    private func lobbyContent(scenario: BossScenario) -> some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .bird3,
            customMascotSize: CGSize(width: 180, height: 180)
        ) {
            VStack(spacing: 16) {
                Text(L10n.BossLevel.phase)
                    .dialogTitleStyle()

                VStack(spacing: 8) {
                    Text(L10n.BossLevel.meetBoss(scenario.bossName))
                        .dialogTitleStyle()

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
                        .dialogTitleStyle()

                    Text(scenario.objective)
                        .dialogSubtitleStyle()
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

    // MARK: - Active Session Content

    private var activeSessionContent: some View {
        VStack(spacing: 16) {
            activeObjective

            DialogCardContainer(
                showMascot: true,
                mascotImage: mascotImageForState,
                customMascotSize: CGSize(width: 120, height: 120)
            ) {
                BossLevelTranscriptView(
                    messages: viewModel.messages,
                    onTapToTalk: { }
                )
                .frame(maxHeight: .infinity)
            }
            .padding(.horizontal, 24)
            .animation(.easeInOut(duration: 0.3), value: mascotImageForState)
        }
        .padding(.top, 8)
    }

    // MARK: - Finish Stage Dialog Content

    private var finishConfirmationDialogContent: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .resetPasswordBird,
            customMascotSize: CGSize(width: 200, height: 200)
        ) {
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
