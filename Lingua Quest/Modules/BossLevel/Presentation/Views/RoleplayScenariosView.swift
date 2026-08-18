

import SwiftUI

struct RoleplayScenariosView: View {
    @State private var viewModel: RoleplayScenariosViewModel

    init(viewModel: RoleplayScenariosViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
                .padding(.top, 8)

            ZStack {
                Color.appBackgroundWarm.ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text(error)
                            .appTextStyle(.body, color: .appTextSecondary)
                        CustomButton(
                            type: .secendry,
                            text: L10n.Common.retry,
                            action: { viewModel.loadScenarios() },
                            status: .enable
                        )
                        .frame(width: 140)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(viewModel.scenarios) { scenario in
                                Button(action: { viewModel.onScenarioSelected(scenario) }) {
                                    RoleplayScenarioCard(scenario: scenario)
                                }
                                .buttonStyle(HomeScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .background(Color.appBackgroundWarm.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .aiUnavailableDialog(isPresented: Bindable(viewModel).showAiUnavailableDialog, onOkTapped: {
            viewModel.onBackTapped()
        })
    }

    private var headerBar: some View {
        ZStack {
            Text(L10n.BossLevel.interactiveRoleplays)
                .appTextStyle(.headingLarge, color: .appTextHeading)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                CustomBackButton(action: { viewModel.onBackTapped() })
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
    }
}

private struct RoleplayScenarioCard: View {
    let scenario: BossScenario

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.appAccentOrange.opacity(0.18))
                        .frame(width: 56, height: 56)

                    Image(systemIcon: .personFill)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.appAccentOrange)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(scenario.bossName)
                        .appTextStyle(.headingMediumBold, color: .appTextHeading)

                    Text(scenario.roleDescription)
                        .appTextStyle(.caption, color: .appTextSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            // Objective container box
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.BossLevel.objectiveTitle)
                    .appTextStyle(.microSemibold, color: .appAccentOrange)

                Text(scenario.objective)
                    .appTextStyle(.bodyBold, color: .appTextHeading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appAccentOrange.opacity(0.08))
            .cornerRadius(14)
        }
        .padding(20)
        .background(Color.appSurfaceCard)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    RoleplayScenariosView(
        viewModel: RoleplayScenariosViewModel(
            scenarioRepository: ScenarioRepositoryImpl(),
            router: Router()
        )
    )
}
