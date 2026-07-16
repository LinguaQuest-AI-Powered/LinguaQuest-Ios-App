//
//  RouterAssembly.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//


import SwiftUI
import Swinject
import Combine

final class RouterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RouterProtocol.self) { _ in Router() }
            .inObjectScope(.container)
        container.register(Router.self) { resolver in
            resolver.resolve(RouterProtocol.self) as! Router
        }.inObjectScope(.container)
    }
}