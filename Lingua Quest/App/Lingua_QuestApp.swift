//
//  Lingua_QuestApp.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

@main
struct MyApp: App {
    init() {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
        _ = Resolver.shared
    }

    var body: some Scene {
        WindowGroup {
           RootView()
        }
    }
}
