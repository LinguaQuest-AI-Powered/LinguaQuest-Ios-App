//
//  ForgetPasswordViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//

import Observation

@Observable
@MainActor
final class ForgetPasswordViewModel {
     var email = ""
    
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func sendResetLink() {
        print("Send reset link tapped for \(email)")
    }
    
    func navigateToLogin() {
        router.pop()
    }
}
