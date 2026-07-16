//
//  AuthAssembly.swift
//  Lingua Quest
//
//  Created by Al3dwy on 14/07/2026.
//

import Swinject

final class AuthAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return LoginViewModel(router: router)
        }
        
        container.register(SignUpViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return SignUpViewModel(router: router)
        }
    }
}
