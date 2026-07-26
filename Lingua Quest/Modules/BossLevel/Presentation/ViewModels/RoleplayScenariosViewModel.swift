

import SwiftUI
import Observation

@MainActor
@Observable
final class RoleplayScenariosViewModel {
    private(set) var scenarios: [BossScenario] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil

    private let scenarioRepository: ScenarioRepositoryProtocol
    private let router: RouterProtocol

    init(
        scenarioRepository: ScenarioRepositoryProtocol,
        router: RouterProtocol
    ) {
        self.scenarioRepository = scenarioRepository
        self.router = router
    }

    func onAppear() {
        loadScenarios()
    }

    func loadScenarios() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                scenarios = try await scenarioRepository.getAllScenarios()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func onScenarioSelected(_ scenario: BossScenario) {
        router.push(.bossLevel(scenarioTitle: scenario.id))
    }

    func onBackTapped() {
        router.pop()
    }
}
