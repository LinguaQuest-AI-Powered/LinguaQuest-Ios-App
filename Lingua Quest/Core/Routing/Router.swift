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
    func pop(count: Int)
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
    
    func pop(count: Int) {
        let itemsToRemove = min(count, path.count)
        guard itemsToRemove > 0 else { return }
        path.removeLast(itemsToRemove)
    }
    
    func popToRoot() { path.removeLast(path.count) }
    func present(_ sheet: AppSheet) { presentedSheet = sheet }
    func dismissSheet() { presentedSheet = nil }

    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .home: MainTabView()
        case .onBoarding: OnboardingContainerView()
        case .completeProfile:
            let viewModel = Resolver.shared.resolve(ProfileCompletionViewModel.self)
            ProfileCompletionContainerView(viewModel: viewModel)
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
        case .cameraQuestTask(let worldId, let worldName, let levelId, let levelOrder, let targetWord):
            let viewModel = Resolver.shared.resolve(CameraTaskQuestViewModel.self, arguments: worldId, worldName, levelId, levelOrder, targetWord)
            CameraTaskQuestView(viewModel: viewModel)
        case .cameraCapture(let worldId, let worldName, let levelId, let levelOrder, let targetWord):
            let viewModel = Resolver.shared.resolve(CameraCaptureViewModel.self, arguments: worldId, worldName, levelId, levelOrder, targetWord)
            CameraCaptureView(viewModel: viewModel)
        case .cameraResult(let worldId, let worldName, let levelId, let levelOrder, let targetWord, let imageData):
            let viewModel = Resolver.shared.resolve(CameraResultViewModel.self, arguments: worldId, worldName, levelId, levelOrder, targetWord, imageData)
            CameraResultView(viewModel: viewModel)
        case .voiceGame:
            let viewModel = Resolver.shared.resolve(VoiceGameViewModel.self)
            VoiceGameView(viewModel: viewModel)
        case .voiceGameResult(let audioData, let sentence):
            let viewModel = Resolver.shared.resolve(VoiceGameResultViewModel.self, argument: (audioData, sentence))
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
            let viewModel = Resolver.shared.resolve(EditProfileViewModel.self)
            EditProfileView(viewModel: viewModel)
        case .bossLevel(let scenarioTitle):
            let viewModel = Resolver.shared.resolve(BossLevelViewModel.self, argument: scenarioTitle)
            BossLevelView(viewModel: viewModel)
        case .roleplayScenarios:
            let viewModel = Resolver.shared.resolve(RoleplayScenariosViewModel.self)
            RoleplayScenariosView(viewModel: viewModel)
        case .mindReaderIntro:
            let viewModel = Resolver.shared.resolve(MindReaderIntroViewModel.self)
            MindReaderIntroView(viewModel: viewModel)
        case .mindReaderGame:
            let viewModel = Resolver.shared.resolve(MindReaderGameViewModel.self)
            MindReaderGameView(viewModel: viewModel)
        case .mindReaderGuess:
            let viewModel = Resolver.shared.resolve(MindReaderGuessViewModel.self)
            MindReaderGuessView(viewModel: viewModel)
        case .mindReaderTranslation:
            let viewModel = Resolver.shared.resolve(MindReaderTranslationViewModel.self)
            MindReaderTranslationView(viewModel: viewModel)
        case .mindReaderResult:
            let viewModel = Resolver.shared.resolve(MindReaderResultViewModel.self)
            MindReaderResultView(viewModel: viewModel)
        case .mindReaderFailure:
            let viewModel = Resolver.shared.resolve(MindReaderFailureViewModel.self)
            MindReaderFailureView(viewModel: viewModel)
        case .mindReaderGiveUp:
            let viewModel = Resolver.shared.resolve(MindReaderGiveUpViewModel.self)
            MindReaderGiveUpView(viewModel: viewModel)
        case .appLanguageSelection:
            let viewModel = Resolver.shared.resolve(SettingsViewModel.self)
            AppLanguageSelectionView(viewModel: viewModel)
        case .about:
            let viewModel = Resolver.shared.resolve(AboutViewModel.self)
            AboutView(viewModel: viewModel)
        case .helpAndSupport:
            let viewModel = Resolver.shared.resolve(HelpAndSupportViewModel.self)
            HelpAndSupportView(viewModel: viewModel)
        case .notifications:
            let viewModel = Resolver.shared.resolve(NotificationsViewModel.self)
            NotificationsView(viewModel: viewModel)
        }
    }
}


