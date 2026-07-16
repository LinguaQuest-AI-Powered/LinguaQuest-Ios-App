//
//  SignUpViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//
import Foundation
import Combine
@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isPasswordVisible = false
    @Published var isConfirmPasswordVisible = false
    
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
        router.popToRoot()
    }
}
