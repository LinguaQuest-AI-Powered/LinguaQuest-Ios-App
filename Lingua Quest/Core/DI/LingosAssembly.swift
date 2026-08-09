//
//  LingosAssembly.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 09/08/2026.
//

import Foundation
import Swinject

class LingosAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(LingosViewModel.self) { resolver in
            LingosViewModel(
                router: resolver.resolve(RouterProtocol.self)!,
                getVoiceProgressUseCase: resolver.resolve(GetVoiceProgressUseCase.self)!,
                statsService: resolver.resolve(StatsService.self)!
            )
        }
    }
}
