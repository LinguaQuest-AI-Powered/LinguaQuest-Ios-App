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
            return AllWorldsViewModel(router: router)
        }
    }
}
