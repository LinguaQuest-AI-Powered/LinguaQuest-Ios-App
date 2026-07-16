//
//  LoginViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 14/07/2026.
//
import Foundation
import Observation
@Observable
@MainActor
final class LoginViewModel {
   
    
    var email = ""
    var password = ""
    var isPasswordVisible = false
    
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func login() {
        print("Login tapped")
    }
    
    func forgotPassword() {
        router.push(.forgetPassword)
    }
    
    func continueWithGoogle() {
        print("Continue with Google tapped")
    }
    
    func continueWithApple() {
        print("Continue with Apple tapped")
    }
    
    func navigateToSignUp() {
        router.push(.signUp)
    }
}
