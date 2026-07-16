//
//  VerifyEmailViewModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 15/07/2026.
//
import Observation
import Foundation


@Observable
@MainActor
final class VerifyEmailViewModel {
     var otpCode = "" {
        didSet {
            if otpCode.count > 4 {
                otpCode = String(otpCode.prefix(4))
            }
        }
    }
    
     var timeRemaining = 59
    
    private let router: RouterProtocol
    private var timer: Timer?
    
    init(router: RouterProtocol) {
        self.router = router
        startTimer()
    }
    
    func startTimer() {
        timeRemaining = 59
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.invalidate()
                }
            }
        }
    }
    
    func verifyCode() {
        print("Verify code tapped: \(otpCode)")
    }
    
    func resendCode() {
        startTimer()
        print("Resend code tapped")
    }
    
    func navigateToLogin() {
        timer?.invalidate()
        router.popToRoot()
    }
    
    
}
