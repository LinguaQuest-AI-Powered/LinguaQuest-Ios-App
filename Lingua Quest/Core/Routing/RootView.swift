//
//  RootView.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

struct RootView: View {
    @State private var router = Resolver.shared.resolve(Router.self)
    @State private var userPreferences = Resolver.shared.resolve(UserPreferencesProtocol.self) as! UserPreferences
    @AppStorage(AppConstants.UserDefaultsKeys.isOnboardingCompleted) private var isOnboardingCompleted = false
    @AppStorage(AppConstants.UserDefaultsKeys.isLoggedIn) private var isLoggedIn = false
    @AppStorage(AppConstants.UserDefaultsKeys.needsProfileCompletion) private var needsProfileCompletion = false
    @State private var networkMonitor = NetworkMonitor.shared
    
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
        .id(userPreferences.appLanguage)
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {
            case .dummy: EmptyView()
            }
        }
        .environment(router)
        .preferredColorScheme(userPreferences.isDarkMode ? .dark : .light)
        .environment(\.locale, Locale(identifier: userPreferences.appLanguage))
        .environment(\.layoutDirection, userPreferences.appLanguage == "ar" ? .rightToLeft : .leftToRight)
        .globalVocabularyDeepLink()
        .appDialog(isPresented: .init(
            get: { !networkMonitor.isConnected },
            set: { _ in }
        )) {
            DialogCardContainer(
                showMascot: true,
                mascotImage: .noInternet,
                speechBubbleText: L10n.Network.noConnection,
                onMascotTap: nil
            ) {
                VStack(spacing: 8) {
                    Text(L10n.Network.offlineTitle)
                        .appTextStyle(.headingLarge, color: .appTextHeading)
                        .multilineTextAlignment(.center)
                    
                    Text(L10n.Network.offlineSubtitle)
                        .appTextStyle(.bodyMedium, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 10)
            }
        }
    }
}
