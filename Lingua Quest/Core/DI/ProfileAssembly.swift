//
//  ProfileAssembly.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Swinject

final class ProfileAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfileViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return ProfileViewModel(router: router)
        }
    }
}
