//
//  Lingua_QuestApp.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import FirebaseCore
import SwiftData

@main
struct MyApp: App {
    init() {
        FirebaseApp.configure()
        _ = Resolver.shared
    }

    var body: some Scene {
        WindowGroup {
           RootView()
        }
        .modelContainer(for: CapturedItemEntity.self)
    }
}
