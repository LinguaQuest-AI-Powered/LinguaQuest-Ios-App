//
//  ResetPasswordViewModel.swift
//  Lingua Quest
//
//  Created by AI on 16/07/2026.
//

import Foundation
import Observation

@Observable
final class ResetPasswordViewModel {
    var newPassword = ""
    var confirmNewPassword = ""
    var isNewPasswordVisible = false
    var isConfirmNewPasswordVisible = false
    
    var passwordStrengthProgress: Double {
        if newPassword.isEmpty { return 0.0 }
        if newPassword.count < 6 { return 0.33 }
        if newPassword.count < 10 { return 0.66 }
        return 1.0
    }
    
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func resetPassword() {
        // Implement the password reset logic here
        router.popToRoot()
    }
    
    func navigateToLogin() {
        router.popToRoot() // or pop depending on the flow
    }
}
