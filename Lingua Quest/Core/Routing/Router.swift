//
//  Router.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import Swinject
internal import Combine

protocol RouterProtocol: AnyObject {
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
    func present(_ sheet: AppSheet)
    func dismissSheet()
}

@MainActor
final class Router: ObservableObject, RouterProtocol {
    @Published var path = NavigationPath()
    @Published var presentedSheet: AppSheet?

    func push(_ route: AppRoute) { path.append(route) }
    func pop() { guard !path.isEmpty else { return }; path.removeLast() }
    func popToRoot() { path.removeLast(path.count) }
    func present(_ sheet: AppSheet) { presentedSheet = sheet }
    func dismissSheet() { presentedSheet = nil }

    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .home: Text("**")
        case .profile(let userId): Text("** \(userId)")
        case .settings: Text("**")
        case .productDetails(let id): Text("** \(id)")
        case .login: 
            let viewModel = Resolver.shared.resolve(LoginViewModel.self)
            LoginView(viewModel: viewModel)
        case .signUp:
            let viewModel = Resolver.shared.resolve(SignUpViewModel.self)
            SignUpView(viewModel: viewModel)
        }
    }
}


