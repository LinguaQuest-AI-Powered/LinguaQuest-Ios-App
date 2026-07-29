//
//  HelpAndSupportViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 28/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class HelpAndSupportViewModel {
    
    // MARK: - Dependencies
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Intentions
    
    func onBackTapped() {
        router.pop()
    }
}
