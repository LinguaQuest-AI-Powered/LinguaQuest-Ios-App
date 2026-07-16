//
//  Resolver.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Swinject

final class Resolver {
    static let shared = Resolver()
    let container: Container

    private init() {
        container = Container()
        registerAssemblies()
    }

    private func registerAssemblies() {
        _ = Assembler(
            [NetworkAssembly(), RouterAssembly(), StorageAssembly(), AuthAssembly()],
            container: container
        )
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let service = container.resolve(type) else {
            fatalError("Failed to resolve type: \(type)")
        }
        return service
    }
}
