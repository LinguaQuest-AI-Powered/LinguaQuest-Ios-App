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
    @State private var isSplashFinished = false
    
    var body: some View {
        ZStack {
            Color(red: 4/255, green: 115/255, blue: 125/255)
                .ignoresSafeArea() // Persistent background to prevent white flashes during transition
            
            Group {
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
            
            if !isSplashFinished {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + SplashConfig.totalDuration) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                isSplashFinished = true
                            }
                        }
                    }
            }
            }
            .id(userPreferences.appLanguage)
            .sheet(item: $router.presentedSheet) { sheet in
                switch sheet {
                case .dummy: EmptyView()
                }
            }
            .environment(router)
            .environment(\.soundPlayer, Resolver.shared.resolve(AppSoundPlayer.self))
            .preferredColorScheme(userPreferences.isDarkMode ? .dark : .light)
            .environment(\.locale, Locale(identifier: userPreferences.appLanguage))
            .environment(\.layoutDirection, userPreferences.appLanguage == "ar" ? .rightToLeft : .leftToRight)
            .globalVocabularyDeepLink()
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PushNotificationTapped"))) { _ in
                if isLoggedIn {
                    router.push(.notifications)
                }
            }
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
                            .dialogTitleStyle()
                            .multilineTextAlignment(.center)
                        
                        Text(L10n.Network.offlineSubtitle)
                            .dialogSubtitleStyle()
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}
