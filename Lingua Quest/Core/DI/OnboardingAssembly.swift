//
//  OnboardingAssembly.swift
//  Lingua Quest
//
//  Created by siam on 16/07/2026.
//

import Swinject

final class OnboardingAssembly: Assembly {
    func assemble(container: Container) {
        container.register(OnboardingViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let userPreferences = resolver.resolve(UserPreferencesProtocol.self)!
            return OnboardingViewModel(router: router, userPreferences: userPreferences)
        }
    }
}
