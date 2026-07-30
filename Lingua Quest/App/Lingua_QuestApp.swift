//
//  Lingua_QuestApp.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import SwiftData
import GoogleSignIn
import ActivityKit

@main
struct MyApp: App {
    init() {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
        _ = Resolver.shared
        
        // Initialize default app language based on device locale if not set
        if UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) == nil {
            let deviceCode = Locale.current.language.languageCode?.identifier ?? "en"
            let isSupported = AppLanguage.allCases.contains(where: { $0.code.lowercased() == deviceCode.lowercased() })
            let defaultCode = isSupported ? deviceCode.lowercased() : "en"
            UserDefaults.standard.set(defaultCode, forKey: AppConstants.UserDefaultsKeys.appLanguage)
        }
    }

    @Environment(\.scenePhase) private var scenePhase
    @State private var lockScreenVocabularyManager = LockScreenVocabularyManager()
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    if url.scheme == "linguaquest" && url.host == "word" {
                        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                           let idStr = components.queryItems?.first(where: { $0.name == "id" })?.value,
                           let id = UUID(uuidString: idStr) {
                            NotificationCenter.default.post(
                                name: NSNotification.Name("VocabularyNotificationTapped"),
                                object: nil,
                                userInfo: ["wordId": id]
                            )
                        }
                    } else {
                        GIDSignIn.sharedInstance.handle(url)
                    }
                }
        }
        .modelContainer(for: [CapturedItemEntity.self, VocabularyWordSwiftDataEntity.self])
        .onChange(of: scenePhase) { oldPhase, newPhase in
            lockScreenVocabularyManager.handleScenePhaseChange(to: newPhase)
        }
    }
}
