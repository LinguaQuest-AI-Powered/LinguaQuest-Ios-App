//
//  ForgetPasswordViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//
import Foundation
import Combine
@MainActor
final class ForgetPasswordViewModel: ObservableObject {
     @Published var email = ""
    
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func sendResetLink() {
        print("Send reset link tapped for \(email)")
        router.push(.verifyEmail)
    }
    
    func navigateToLogin() {
        router.pop()
    }
}
