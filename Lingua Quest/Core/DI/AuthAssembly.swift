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
            let userPreferences = resolver.resolve(UserPreferencesProtocol.self)!
            return LoginViewModel(router: router, userPreferences: userPreferences)
        }
        
        container.register(SignUpViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return SignUpViewModel(router: router)
        }
        
        container.register(ForgetPasswordViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return ForgetPasswordViewModel(router: router)
        }
        
        container.register(VerifyEmailViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return VerifyEmailViewModel(router: router)
        }
        
        container.register(ResetPasswordViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return ResetPasswordViewModel(router: router)
        }
    }
}
