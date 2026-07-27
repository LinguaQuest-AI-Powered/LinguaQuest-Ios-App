//
//  RootView.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

struct RootView: View {
    @State private var router = Resolver.shared.resolve(Router.self)
    @AppStorage(AppConstants.UserDefaultsKeys.isOnboardingCompleted) private var isOnboardingCompleted = false
    @AppStorage(AppConstants.UserDefaultsKeys.isLoggedIn) private var isLoggedIn = false
    @AppStorage(AppConstants.UserDefaultsKeys.needsProfileCompletion) private var needsProfileCompletion = false
    @AppStorage(AppConstants.UserDefaultsKeys.isDarkMode) private var isDarkMode = false
    @AppStorage(AppConstants.UserDefaultsKeys.appLanguage) private var appLanguage = "en"
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if !isOnboardingCompleted {
                    router.view(for: .onBoarding)
                } else if isLoggedIn && needsProfileCompletion {
                    router.view(for: .completeProfile)
                } else if isLoggedIn {
                    router.view(for: .home)
                } else {
                    router.view(for: .login)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                router.view(for: route)
            }
        }
        .id(appLanguage)
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {
            case .dummy: EmptyView()
            }
        }
        .environment(router)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.locale, Locale(identifier: appLanguage))
        .environment(\.layoutDirection, appLanguage == "ar" ? .rightToLeft : .leftToRight)
        .globalVocabularyDeepLink()
    }
}
