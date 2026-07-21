//
//  AllWorldsAssembly.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import Swinject

final class AllWorldsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AllWorldsViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let getHomeWorldsUseCase = resolver.resolve(GetHomeWorldsUseCaseProtocol.self)!
            return AllWorldsViewModel(router: router, getHomeWorldsUseCase: getHomeWorldsUseCase)
        }
    }
}
