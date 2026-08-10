//
//  DailyMissionCard.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import SwiftUI

struct DailyMissionCard: View {
    @State var viewModel: DailyMissionCardViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection

    @State private var mascotBounce = false
    @State private var buttonPulse = false
    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        Group {
            if case .loading = viewModel.state {
                skeletonView
            } else {
                cardContent
                    .onAppear {
                        startAnimations()
                    }
            }
        }
    }

    // MARK: - Skeleton View

    private var skeletonView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.2)).frame(width: 100, height: 20)
                    RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.2)).frame(width: 180, height: 24)
                }
                Spacer()
            }
            .padding(.horizontal, 18).padding(.top, 18)
            
            HStack {
                RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.2)).frame(height: 72)
                Circle().fill(Color.gray.opacity(0.2)).frame(width: 80, height: 80).padding(.leading, 8)
            }
            .padding(.horizontal, 18).padding(.top, 10).padding(.bottom, 14)
            
            Spacer(minLength: 0)
            
            RoundedRectangle(cornerRadius: 25).fill(Color.gray.opacity(0.2)).frame(height: 50)
                .padding(.horizontal, 18).padding(.bottom, 18)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(cardBorder)
        .shadow(
            color: Color.appAccentOrange.opacity(colorScheme == .dark ? 0.12 : 0.08),
            radius: 20, x: 0, y: 10
        )
        .redacted(reason: .placeholder)
        .shimmer()
    }

    // MARK: - Card Content

    @ViewBuilder
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
                .padding(.horizontal, 18)
                .padding(.top, 18)

            centerSection
                .padding(.top, 10)
                .padding(.bottom, 14)

            Spacer(minLength: 0)

            actionSection
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(cardBorder)
        .shadow(
            color: Color.appAccentOrange.opacity(colorScheme == .dark ? 0.12 : 0.08),
            radius: 20, x: 0, y: 10
        )
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text(L10n.DailyMission.title)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(.appAccentOrange)
                } icon: {
                    Image(systemIcon: .starCircleFill)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.appAccentOrange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.appAccentOrange.opacity(0.12))
                .cornerRadius(6)

                Text(L10n.DailyMission.subtitle)
                    .font(AppTextStyle.headingMediumBold.font)
                    .foregroundColor(.appTextHeading)
                    .lineLimit(2)
            }

            Spacer()
        }
    }

    // MARK: - Center (Mascot + Word)

    @ViewBuilder
    private var centerSection: some View {
        HStack(spacing: -65) {
            // Word/State display
            wordStateView
                .environment(\.layoutDirection, layoutDirection) // Restore original language direction INSIDE
                .frame(maxWidth: .infinity)
                .padding(.leading, 18) // Padding evaluates in the HStack's LTR environment

            // Lingo mascot peeking from the edge and overlapping box
            Image(asset: .dailyMission)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .offset(x: 30, y: mascotBounce ? -20 : -13)
                .zIndex(1)
        }
        .padding(.trailing, 9) // Prevents the right side of the mascot from being clipped by the card edge
        .environment(\.layoutDirection, .leftToRight) // Force LTR so image stays on the right
    }

    @ViewBuilder
    private var wordStateView: some View {
        switch viewModel.state {
        case .loading:
            EmptyView()

        case .available(let word):
            VStack(spacing: 8) {
                Text(word)
                    .font(AppTextStyle.displayLarge.font)
                    .foregroundColor(.appTextSecondary)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, minHeight: 86)
                    .background(Color.appSurfaceCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.appAccentOrange, lineWidth: 2)
                    )
                    .shadow(color: Color.appAccentOrange.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))

        case .completed:
            HStack(spacing: 10) {
                Image(systemIcon: .checkmarkCircleFill)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.appSemanticSuccess)
                Text(L10n.DailyMission.completed)
                    .font(AppTextStyle.bodyLargeMedium.font)
                    .foregroundColor(.appSemanticSuccess)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 72)
            .background(Color.appSemanticSuccess.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .transition(.opacity.combined(with: .scale(scale: 0.95)))

        case .notAvailable:
            VStack(spacing: 6) {
                Image(systemIcon: .moonFill)
                    .font(.system(size: 22))
                    .foregroundColor(.appTextSecondary)
                Text(L10n.DailyMission.notAvailableSubtitle)
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 72)
            .background(Color.appSurfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))

        case .error:
            VStack(spacing: 6) {
                Image(systemIcon: .exclamationmarkCircle)
                    .font(.system(size: 22))
                    .foregroundColor(.appAccentOrange)
                Button(action: viewModel.onRetryTapped) {
                    Text(L10n.Common.retry)
                        .font(AppTextStyle.captionBold.font)
                        .foregroundColor(.appAccentOrange)
                        .underline()
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 72)
            .background(Color.appSurfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Action Button

    @ViewBuilder
    private var actionSection: some View {
        switch viewModel.state {
        case .available:
            Button(action: viewModel.onCaptureNowTapped) {
                HStack(spacing: 8) {
                    Image(systemIcon: .camera)
                        .font(.system(size: 16, weight: .bold))
                    Text(L10n.DailyMission.captureNow)
                        .font(AppTextStyle.bodyLargeBold.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    ZStack {
                        Capsule()
                            .fill(Color.appAccentOrange)
                        
                        // Shimmer effect
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .white.opacity(0.2),
                                        .clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .mask(Capsule())
                    }
                )
                .clipShape(Capsule())
                .shadow(
                    color: Color.appAccentOrange.opacity(buttonPulse ? 0.45 : 0.2),
                    radius: buttonPulse ? 14 : 8,
                    x: 0, y: 4
                )
            }
            .buttonStyle(.plain)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.3)) {
                    buttonPulse = true
                }
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false).delay(1.0)) {
                    shimmerOffset = 400
                }
            }

        case .completed:
            HStack(spacing: 8) {
                Image(systemIcon: .checkmarkCircleFill)
                Text(L10n.DailyMission.completed)
                    .font(AppTextStyle.bodyLargeMedium.font)
            }
            .foregroundColor(.appSemanticSuccess.opacity(0.7))
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.appSemanticSuccess.opacity(0.1))
            .clipShape(Capsule())

        case .loading:
            EmptyView()

        default:
            EmptyView()
        }
    }

    // MARK: - Background & Border

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.95 : 0.98))
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .stroke(
                Color.appAccentOrange.opacity(colorScheme == .dark ? 0.25 : 0.18),
                lineWidth: 1.5
            )
    }

    // MARK: - Animations

    private func startAnimations() {
        guard !reduceMotion else { return }
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            mascotBounce = true
        }
    }
}

