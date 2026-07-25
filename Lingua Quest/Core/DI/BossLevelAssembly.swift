//
//  BossLevelAssembly.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Swinject

final class BossLevelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LiveRoleplayService.self) { _ in
            LiveRoleplayService()
        }.inObjectScope(.container)
        
        container.register(BossLevelRepositoryProtocol.self) { r in
            let liveService = r.resolve(LiveRoleplayService.self)!
            return BossLevelRepositoryImpl(liveService: liveService)
        }.inObjectScope(.container)
        
        container.register(StartBossLevelSessionUseCaseProtocol.self) { r in
            let repo = r.resolve(BossLevelRepositoryProtocol.self)!
            return StartBossLevelSessionUseCase(repository: repo)
        }
        
        container.register(StopBossLevelSessionUseCaseProtocol.self) { r in
            let repo = r.resolve(BossLevelRepositoryProtocol.self)!
            return StopBossLevelSessionUseCase(repository: repo)
        }
        
        container.register(ScenarioRepositoryProtocol.self) { _ in
            return ScenarioRepositoryImpl()
        }
        
        container.register(EvaluateBossStageUseCaseProtocol.self) { r in
            let repo = r.resolve(BossLevelRepositoryProtocol.self)!
            return EvaluateBossStageUseCase(repository: repo)
        }
        
        container.register(BossLevelViewModel.self) { (r, scenarioId: String) in
            BossLevelViewModel(
                scenarioId: scenarioId,
                scenarioRepository: r.resolve(ScenarioRepositoryProtocol.self)!,
                repository: r.resolve(BossLevelRepositoryProtocol.self)!,
                startSessionUseCase: r.resolve(StartBossLevelSessionUseCaseProtocol.self)!,
                stopSessionUseCase: r.resolve(StopBossLevelSessionUseCaseProtocol.self)!,
                evaluateStageUseCase: r.resolve(EvaluateBossStageUseCaseProtocol.self)!,
                router: r.resolve(RouterProtocol.self)!
            )
        }
        
        container.register(BossLevelViewModel.self) { r in
            BossLevelViewModel(
                scenarioId: "scenario_market_01",
                scenarioRepository: r.resolve(ScenarioRepositoryProtocol.self)!,
                repository: r.resolve(BossLevelRepositoryProtocol.self)!,
                startSessionUseCase: r.resolve(StartBossLevelSessionUseCaseProtocol.self)!,
                stopSessionUseCase: r.resolve(StopBossLevelSessionUseCaseProtocol.self)!,
                evaluateStageUseCase: r.resolve(EvaluateBossStageUseCaseProtocol.self)!,
                router: r.resolve(RouterProtocol.self)!
            )
        }
    }
}
