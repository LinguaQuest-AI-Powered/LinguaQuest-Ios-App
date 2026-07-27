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
        wireCircularDependencies()
        _ = container.resolve(SessionManagerProtocol.self) // force-instantiate to start listening for .sessionExpired
        _ = container.resolve(StatsServiceProtocol.self) // force-instantiate singleton service
    }

    private func registerAssemblies() {
        _ = Assembler(
            [
                NetworkAssembly(), RouterAssembly(), StorageAssembly(),
                AuthAssembly(), OnboardingAssembly(), GameAssembly(), GalleryAssembly(),
                ProfileAssembly(), HomeAssembly(),
                SpeakingLabAssembly(), BossLevelAssembly(),
                SessionAssembly(),
                StatsAssembly(),
               
                LockScreenVocabularyAssembly()
            ],
            container: container
        )
    }
    
    
    /// Wires dependencies that can't be expressed through normal constructor injection
    /// because they'd create a circular object graph at registration time.
    /// Currently: APIClient <-> AuthTokenProvider <-> AuthRemoteDataSource(APIClient).
    private func wireCircularDependencies() {
        guard let apiClient = container.resolve(APIClientProtocol.self) as? APIClient else { return }
        apiClient.tokenProvider = container.resolve(AuthTokenProviding.self)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let service = container.resolve(type) else {
            fatalError("Failed to resolve type: \(type)")
        }
        return service
    }
    
    func resolve<T, Arg1>(_ type: T.Type, argument: Arg1) -> T {
        guard let service = container.resolve(type, argument: argument) else {
            fatalError("Failed to resolve type: \(type) with argument: \(argument)")
        }
        return service
    }
    
    func resolve<T, Arg1, Arg2>(_ type: T.Type, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let service = container.resolve(type, arguments: arg1, arg2) else {
            fatalError("Failed to resolve type: \(type) with arguments: \(arg1), \(arg2)")
        }
        return service
    }
    
    func resolve<T, Arg1, Arg2, Arg3>(_ type: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T {
        guard let service = container.resolve(type, arguments: arg1, arg2, arg3) else {
            fatalError("Failed to resolve type: \(type) with arguments: \(arg1), \(arg2), \(arg3)")
        }
        return service
    }
    
    func resolve<T, Arg1, Arg2, Arg3, Arg4>(_ type: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> T {
        guard let service = container.resolve(type, arguments: arg1, arg2, arg3, arg4) else {
            fatalError("Failed to resolve type: \(type) with arguments: \(arg1), \(arg2), \(arg3), \(arg4)")
        }
        return service
    }
    
    func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5>(_ type: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> T {
        guard let service = container.resolve(type, arguments: arg1, arg2, arg3, arg4, arg5) else {
            fatalError("Failed to resolve type: \(type) with arguments: \(arg1), \(arg2), \(arg3), \(arg4), \(arg5)")
        }
        return service
    }
}
