//
//  NetworkAssembly.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Swinject

final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(APIClientProtocol.self) { _ in APIClient() }
            .inObjectScope(.container)
    }
}
