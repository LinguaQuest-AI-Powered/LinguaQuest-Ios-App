//
//  RootView.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = Resolver.shared.resolve(Router.self)
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some View {
        Group {
            if !isOnboardingCompleted {
                OnboardingContainerView()
            } else {
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
        .task {
            isOnboardingCompleted = false //TODO: this line is for testing onbarding only so after finish remove it
        }
    }
}
