//
//  SettingsAssembly.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Swinject

final class SettingsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SettingsViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return SettingsViewModel(router: router)
        }
    }
}
