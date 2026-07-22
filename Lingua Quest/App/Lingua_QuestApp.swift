//
//  Lingua_QuestApp.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import FirebaseCore
import SwiftData
import GoogleSignIn

@main
struct MyApp: App {
    init() {
        FirebaseApp.configure()
        _ = Resolver.shared
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
        .modelContainer(for: CapturedItemEntity.self)
    }
}
