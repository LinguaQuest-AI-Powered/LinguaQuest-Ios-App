//
//  AboutViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 27/07/2026.
//

import SwiftUI
import Observation
import StoreKit

@MainActor
@Observable
final class AboutViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    
    // MARK: - Properties
    var showLicensesDialog: Bool = false
    var showComingSoonDialog: Bool = false
    
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
    
    func onRateAppTapped() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func onInstagramTapped() {
        showComingSoonDialog = true
    }
    
    func onWebsiteTapped() {
        showComingSoonDialog = true
    }
    
    func onTermsTapped() {
        showComingSoonDialog = true
    }
    
    func onPrivacyTapped() {
        showComingSoonDialog = true
    }
    
    func onLicensesTapped() {
        showLicensesDialog = true
    }
}
