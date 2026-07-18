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
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if !isOnboardingCompleted {
                    router.view(for: .home) // change it
                } else {
                    if isLoggedIn {
                        router.view(for: .home)
                    } else {
                        router.view(for: .login)
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                router.view(for: route)
            }
        }
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {
            case .editProfile: Text("**")
            }
        }
        .environment(router)
        .task {
            isOnboardingCompleted = false //TODO: this line is for testing onbarding only so after finish remove it
        }
    }
}
