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
        case .verifyEmail(let email):
            let viewModel = Resolver.shared.resolve(VerifyEmailViewModel.self, argument: email)
            VerifyEmailView(viewModel: viewModel)
        case .verifyPasswordResetOtp(let email):
            let viewModel = Resolver.shared.resolve(VerifyPasswordResetOtpViewModel.self, argument: email)
            VerifyPasswordResetOtpView(viewModel: viewModel)
        case .resetPassword(let resetToken):
            let viewModel = Resolver.shared.resolve(ResetPasswordViewModel.self, argument: resetToken)
            ResetPasswordView(viewModel: viewModel)
        case .gameLevels(let worldId, let worldName, let languageId):
            let viewModel = Resolver.shared.resolve(GameLevelsViewModel.self)
            GameLevelsView(viewModel: viewModel, worldName: worldName, worldId: worldId, languageId: languageId)
        case .cameraQuestTask:
            let viewModel = Resolver.shared.resolve(CameraTaskQuestViewModel.self)
            CameraTaskQuestView(viewModel: viewModel)
        case .cameraCapture(let targetWord):
            let viewModel = Resolver.shared.resolve(CameraCaptureViewModel.self, argument: targetWord)
            CameraCaptureView(viewModel: viewModel)
        case .cameraResult(let targetWord, let imageData):
            let viewModel = Resolver.shared.resolve(CameraResultViewModel.self, arguments: targetWord, imageData)
            CameraResultView(viewModel: viewModel)
        case .voiceGame:
            let viewModel = Resolver.shared.resolve(VoiceGameViewModel.self)
            VoiceGameView(viewModel: viewModel)
        case .voiceGameResult:
            let viewModel = Resolver.shared.resolve(VoiceGameResultViewModel.self)
            VoiceGameResultView(viewModel: viewModel)
        case .leaderboard(let languageId):
            let viewModel = Resolver.shared.resolve(LeaderboardViewModel.self, argument: languageId)
            LeaderboardView(viewModel: viewModel)
        case .achievements:
            let viewModel = Resolver.shared.resolve(AchievementsViewModel.self)
            AchievementsView(viewModel: viewModel)
        case .wordInsight(let word):
            let viewModel = Resolver.shared.resolve(WordInsightViewModel.self)
            WordInsightView(viewModel: viewModel, word: word)
        case .allWorlds:
            let viewModel = Resolver.shared.resolve(AllWorldsViewModel.self)
            AllWorldsView(viewModel: viewModel)
        case .editProfile:
            EditProfileView()
        }
    }
}


