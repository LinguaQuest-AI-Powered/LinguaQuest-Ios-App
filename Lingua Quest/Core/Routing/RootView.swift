//
//  RootView.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = Resolver.shared.resolve(Router.self)

    var body: some View {
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
