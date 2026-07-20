//
//  NetworkAssembly.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Swinject

final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(APIClientProtocol.self) { resolver in
            let tokenStorage = resolver.resolve(SecureTokenStorageProtocol.self)
            return APIClient(tokenStorage: tokenStorage)
        }
        .inObjectScope(.container)
    }
}
