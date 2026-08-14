//
//  DailyMissionCardViewModel.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation
import Observation

enum DailyMissionCardState {
    case loading
    case available(word: String)
    case completed
    case notAvailable
    case error
}

@Observable
@MainActor
final class DailyMissionCardViewModel {
    var state: DailyMissionCardState = .loading

    private let getMissionUseCase: GetDailyMissionUseCase
    private let router: RouterProtocol
    
    private var languageSwitchToken: NotificationToken?

    init(getMissionUseCase: GetDailyMissionUseCase, router: RouterProtocol) {
        self.getMissionUseCase = getMissionUseCase
        self.router = router
        
        let token = NotificationCenter.default.addObserver(
            forName: .languageDidSwitch,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task {
                await self?.loadMission()
            }
        }
        languageSwitchToken = NotificationToken(token: token)
    }

    func loadMission() async {

        if case .available = state {
            // Do not show loading if we already have data (silent refresh)
        } else {
            state = .loading
        }
        
        do {
            let entity = try await getMissionUseCase.execute()
            if entity.isSolved {
                self.state = .completed
            } else {
                self.state = .available(word: entity.word)
            }
        } catch let error as NetworkError {
            switch error {
            case .serverError(let code, _) where code == 404:
                self.state = .notAvailable
            default:
                self.state = .error
            }
        } catch {
            self.state = .error
        }
    }

    func onCaptureNowTapped() {
        guard case .available(let word) = state else { return }
        router.push(.dailyMissionCapture(word: word))
    }

    func onRetryTapped() {
        Task {
            await loadMission()
        }
    }
}
