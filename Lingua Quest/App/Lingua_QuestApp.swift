//
//  Lingua_QuestApp.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

@main
struct MyApp: App {
    init() {
        _ = Resolver.shared
    }

    var body: some Scene {
        WindowGroup {
           RootView()
        }
    }
}
