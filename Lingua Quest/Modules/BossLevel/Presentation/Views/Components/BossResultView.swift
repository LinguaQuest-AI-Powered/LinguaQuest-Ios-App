
import SwiftUI

struct BossResultView: View {
    let result: BossEvaluationResult
    let onCloseTapped: () -> Void

    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                DialogCardContainer(
                    showMascot: true,
                    mascotImage: result.task_completed ? .perfect : .weakPasswordBird,
                    customMascotSize: CGSize(width: 180, height: 180)
                ) {
                    VStack(spacing: 20) {
                        // Title
                        Text(result.task_completed
                             ? L10n.BossLevel.resultVictory
                             : L10n.BossLevel.resultStageFailed)
                            .appTextStyle(.headingLarge,
                                          color: result.task_completed ? .appSemanticSuccess : .appAccentRed)
                            .multilineTextAlignment(.center)

                        Text("\(result.fluency_score)%")
                            .appTextStyle(.headingLarge, color: .appTextHeading)

                        Text(result.feedback_message)
                            .appTextStyle(.bodyMedium, color: .appTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 8)

                        CustomButton(
                            type: .custom(
                                textColor: .appTextHeading,
                                buttonColor: .appAccentOrange,
                                shadowColor: .appBrandBrownDark
                            ),
                            text: result.task_completed
                                ? L10n.BossLevel.resultFinish
                                : L10n.BossLevel.resultTryAgain,
                            action: onCloseTapped,
                            status: .enable
                        )
                        .padding(.top, 4)
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}
