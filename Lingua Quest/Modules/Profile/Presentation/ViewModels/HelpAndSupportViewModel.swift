//
//  HelpAndSupportViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 28/07/2026.
//

import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class HelpAndSupportViewModel {
    
    // MARK: - Dependencies
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Intentions
    
    var showEmailCopiedDialog: Bool = false
    
    func onBackTapped() {
        router.pop()
    }
    
    func onContactUsTapped() {
        openMail(subject: "LinguaQuest Support", body: "")
    }
    
    func onReportBugTapped() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        let systemVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.model
        
        let subject = L10n.HelpSupport.bugReportSubject
        let body = String(format: L10n.HelpSupport.bugReportBody, "v\\(version) (\\(build))", model, systemVersion)
        
        openMail(subject: subject, body: body)
    }
    
    private func openMail(subject: String, body: String) {
        let email = "support@linguaquest.app"
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailto = "mailto:\\(email)?subject=\\(subjectEncoded)&body=\\(bodyEncoded)"
        
        if let url = URL(string: mailto), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIPasteboard.general.string = email
            showEmailCopiedDialog = true
        }
    }
}
