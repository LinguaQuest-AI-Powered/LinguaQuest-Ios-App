//
//  SignUpViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//
import Observation

@Observable
@MainActor
final class SignUpViewModel {
     var username = ""
    var email = ""
    var password = ""
     var confirmPassword = ""
    
    var isPasswordVisible = false
     var isConfirmPasswordVisible = false
    
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func createAccount() {
        print("Create account tapped")
    }
    
    func continueWithGoogle() {
        print("Continue with Google tapped")
    }
    
    func continueWithApple() {
        print("Continue with Apple tapped")
    }
    
    func navigateToLogin() {
        router.pop()
    }
}
