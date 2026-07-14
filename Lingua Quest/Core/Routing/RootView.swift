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
    
    var body: some View {
        Group {
            if showSplash {
                SplashView()
                    .transition(.opacity)
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
        .animation(.easeInOut(duration: 0.4), value: showSplash)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showSplash = false
        }
    }
}
