import SwiftUI

struct BossResultView: View {
    let result: BossEvaluationResult
    let coins: Int
    let onCloseTapped: () -> Void
    
    @State private var coinBadgeCenter: CGPoint = .zero
    @State private var coinCardCenter: CGPoint = .zero

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    CustomBackButton(action: onCloseTapped)
                    Spacer()
                    RewardBadge(type: .coin, value: coins.formattedStatsValue(), size: .small)
                        .background(GeometryReader { geo in
                            Color.clear.onAppear {
                                let frame = geo.frame(in: .named("global"))
                                DispatchQueue.main.async {
                                    self.coinBadgeCenter = CGPoint(x: frame.midX, y: frame.midY)
                                }
                            }
                        })
                }
                .padding(.horizontal, 20)
                .frame(height: 64)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        DialogCardContainer(
                            showMascot: true,
                            mascotImage: result.task_completed ? .perfect : .weakPasswordBird,
                            customMascotSize: CGSize(width: 180, height: 180)
                        ) {
                            VStack(spacing: 16) {
                                // Title and Stars
                                VStack(spacing: 8) {
                                    Text(result.task_completed ? L10n.BossLevel.resultVictory : L10n.BossLevel.resultStageFailed)
                                        .dialogTitleStyle()
                                        .padding(.top, 16)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(0..<3, id: \.self) { index in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 28))
                                                .foregroundColor(index < result.earnedStars ? .appAccentGold : .appBorderCool)
                                        }
                                    }
                                    
                                    Text(result.task_completed ? L10n.BossLevel.outstanding : L10n.BossLevel.needsWork)
                                        .appTextStyle(.headingMedium, color: result.task_completed ? .appAccentOrange : .appTextSecondary)
                                }
                                
                                // Scores
                                HStack(alignment: .top, spacing: 0) {
                                    scoreItem(title: L10n.BossLevel.overallFluency, score: result.fluency_score)
                                    Divider().frame(height: 40)
                                    scoreItem(title: L10n.BossLevel.grammar, score: result.grammar_score)
                                    Divider().frame(height: 40)
                                    scoreItem(title: L10n.BossLevel.vocabulary, score: result.vocabulary_score)
                                }
                                .padding(.horizontal, 8)
                                
                                // Feedback Container
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(result.feedback_message)
                                        .appTextStyle(.bodyMedium, color: .appTextSecondary)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    if !result.what_went_well.isEmpty {
                                        feedbackSection(title: L10n.BossLevel.whatWentWell, items: result.what_went_well, isPositive: true)
                                    }
                                    
                                    if !result.areas_to_improve.isEmpty {
                                        feedbackSection(title: L10n.BossLevel.areasToImprove, items: result.areas_to_improve, isPositive: false)
                                    }
                                }
                                .padding(20)
                                .background(Color.appBackgroundWarm.opacity(0.5))
                                .cornerRadius(16)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 16)

                                if result.task_completed, let reward = result.reward {
                                    HStack(spacing: 16) {
                                        RewardCardView(
                                            type: .xp,
                                            title: L10n.MindReader.experience,
                                            amount: reward.xp
                                        )
                                        RewardCardView(
                                            type: .coin,
                                            title: L10n.MindReader.earnings,
                                            amount: reward.coins
                                        )
                                        .background(GeometryReader { geo in
                                            Color.clear.onAppear {
                                                let frame = geo.frame(in: .named("global"))
                                                DispatchQueue.main.async {
                                                    self.coinCardCenter = CGPoint(x: frame.midX, y: frame.midY)
                                                }
                                            }
                                        })
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                                }

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
                        .padding(.top, 40)
                        .padding(.bottom, 24)
                    }
                }
            }
            
            if result.task_completed {
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
    }
    
    
    private func scoreItem(title: String, score: Int) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.appAccentOrange.opacity(0.2), lineWidth: 4)
                
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100.0)
                    .stroke(Color.appAccentOrange, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("\(score)%")
                    .appTextStyle(.bodyBold, color: .appBrandBrown)
            }
            .frame(width: 60, height: 60)
            
            Text(title)
                .appTextStyle(.caption, color: .appTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func feedbackSection(title: String, items: [String], isPositive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .appTextStyle(.bodySemibold, color: isPositive ? .appSemanticSuccess : .appAccentOrange)
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: isPositive ? "checkmark" : "lightbulb.fill")
                        .foregroundColor(isPositive ? .appSemanticSuccess : .appAccentOrange)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.top, 2)
                    
                    Text(item)
                        .appTextStyle(.body, color: .appTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
