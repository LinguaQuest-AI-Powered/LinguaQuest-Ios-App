//
//  GalleryAssembly.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Swinject

final class GalleryAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(GalleryRepositoryProtocol.self) { _ in
            GalleryRepositoryImpl()
        }
        
        container.register(GetCapturedItemsUseCase.self) { r in
            GetCapturedItemsUseCase(repository: r.resolve(GalleryRepositoryProtocol.self)!)
        }
        
        container.register(SaveCapturedItemUseCase.self) { r in
            SaveCapturedItemUseCase(repository: r.resolve(GalleryRepositoryProtocol.self)!)
        }
        
        container.register(GalleryViewModel.self) { r in
            GalleryViewModel(
                getCapturedItemsUseCase: r.resolve(GetCapturedItemsUseCase.self)!,
                saveCapturedItemUseCase: r.resolve(SaveCapturedItemUseCase.self)!,
                router: r.resolve(RouterProtocol.self)!,
                userPreferences: r.resolve(UserPreferencesProtocol.self)!
            )
        }
    }
}
