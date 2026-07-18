//
//  Router.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import Swinject
import Observation

protocol RouterProtocol: AnyObject {
    func push(_ route: AppRoute)
    func pushAndReplace(_ route: AppRoute)
    func pushAndRemoveAll(_ route: AppRoute)
    func pop()
    func popToRoot()
    func present(_ sheet: AppSheet)
    func dismissSheet()
}

@Observable
@MainActor
final class Router: RouterProtocol {
    var path = NavigationPath()
    var presentedSheet: AppSheet?

    func push(_ route: AppRoute) { path.append(route) }
    
    func pushAndReplace(_ route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
    
    func pushAndRemoveAll(_ route: AppRoute) {
        path.removeLast(path.count)
        path.append(route)
    }
    
    func pop() { guard !path.isEmpty else { return }; path.removeLast() }
    func popToRoot() { path.removeLast(path.count) }
    func present(_ sheet: AppSheet) { presentedSheet = sheet }
    func dismissSheet() { presentedSheet = nil }

    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .home: MainTabView()
        case .onBoarding: OnboardingContainerView()
        case .profile(let userId): Text("** \(userId)")
        case .settings:
            let viewModel = Resolver.shared.resolve(SettingsViewModel.self)
            SettingsView(viewModel: viewModel)
        case .login:
            let viewModel = Resolver.shared.resolve(LoginViewModel.self)
            LoginView(viewModel: viewModel)
        case .signUp:
            let viewModel = Resolver.shared.resolve(SignUpViewModel.self)
            SignUpView(viewModel: viewModel)
        case .forgetPassword:
            let viewModel = Resolver.shared.resolve(ForgetPasswordViewModel.self)
            ForgetPasswordView(viewModel: viewModel)
        case .verifyEmail:
            let viewModel = Resolver.shared.resolve(VerifyEmailViewModel.self)
            VerifyEmailView(viewModel: viewModel)
        case .resetPassword:
            let viewModel = Resolver.shared.resolve(ResetPasswordViewModel.self)
            ResetPasswordView(viewModel: viewModel)
        case .gameLevels(let worldName):
            let viewModel = Resolver.shared.resolve(GameLevelsViewModel.self)
            GameLevelsView(viewModel: viewModel, worldName: worldName)
        case .cameraQuestTask:
            let viewModel = Resolver.shared.resolve(CameraTaskQuestViewModel.self)
            CameraTaskQuestView(viewModel: viewModel)
        }
    }
}


