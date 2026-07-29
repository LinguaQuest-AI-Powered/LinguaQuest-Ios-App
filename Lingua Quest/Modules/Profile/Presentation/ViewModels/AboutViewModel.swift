//
//  AboutViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 27/07/2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class AboutViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    
    // MARK: - Properties
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }
    
    // MARK: - Initialization
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Actions
    func onBackTapped() {
        router.pop()
    }
}
