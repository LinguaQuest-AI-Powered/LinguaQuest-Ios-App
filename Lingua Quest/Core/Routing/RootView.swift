//
//  RootView.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = Resolver.shared.resolve(Router.self)
    @State private var showSplash = true
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some View {
        Group {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else if !isOnboardingCompleted {
                OnboardingContainerView()
            }
            else {
                NavigationStack(path: $router.path) {
                    router.view(for: .home)
                        .navigationDestination(for: AppRoute.self) { route in
                            router.view(for: route)
                        }
                }
                .sheet(item: $router.presentedSheet) { sheet in
                    switch sheet {
                    case .login: Text("**")
                    case .editProfile: Text("**")
                    }
                }
                .environmentObject(router)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showSplash)
        .task {
            isOnboardingCompleted = false //TODO: this line is for testing onbarding only so after finish remove it
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showSplash = false
        }
    }
}
