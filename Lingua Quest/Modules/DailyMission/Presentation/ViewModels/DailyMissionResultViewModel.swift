//
//  DailyMissionResultViewModel.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation
import Observation

enum DailyMissionResultState: Equatable {
    case loading
    case match
    case notMatch
    case alreadySolved
    case error(message: String)
}

@Observable
@MainActor
final class DailyMissionResultViewModel {
    let targetWord: String
    let imageData: Data?

    var state: DailyMissionResultState = .loading
    var xpEarned: Int = 0
    var coinsEarned: Int = 0

    var coins: Int { statsService.coins }

    private let verifyUseCase: VerifyDailyMissionUseCase
    private let statsService: StatsServiceProtocol
    private let router: RouterProtocol
    private let soundPlayer: AppSoundPlayer

    init(
        targetWord: String,
        imageData: Data?,
        verifyUseCase: VerifyDailyMissionUseCase,
        statsService: StatsServiceProtocol,
        router: RouterProtocol,
        soundPlayer: AppSoundPlayer
    ) {
        self.targetWord = targetWord
        self.imageData = imageData
        self.verifyUseCase = verifyUseCase
        self.statsService = statsService
        self.router = router
        self.soundPlayer = soundPlayer

        verifyMission()
    }

    // MARK: - Private

    private func verifyMission() {
        guard let data = imageData else {
            state = .error(message: L10n.DailyMission.noImageData)
            return
        }

        Task {
            do {
                let entity = try await verifyUseCase.execute(imageData: data, word: targetWord)

                if entity.isMatch {
                    self.xpEarned = entity.xpEarned
                    self.coinsEarned = entity.coinsEarned
                    self.statsService.syncBalances(
                        coins: self.statsService.coins + entity.coinsEarned,
                        xp: self.statsService.xp + entity.xpEarned,
                        streakDays: nil
                    )
                    self.state = .match
                    soundPlayer.play(sound: .success)
                } else {
                    self.state = .notMatch
                    soundPlayer.play(sound: .fail)
                }
            } catch let error as NetworkError {
                soundPlayer.play(sound: .fail)
                // 409 = already solved today
                if case .serverError(let code, _) = error, code == 409 {
                    self.state = .alreadySolved
                } else if let message = error.apiErrorMessage {
                    self.state = .error(message: message)
                } else {
                    self.state = .error(message: error.localizedDescription)
                }
            } catch {
                soundPlayer.play(sound: .fail)
                self.state = .error(message: error.localizedDescription)
            }
        }
    }

    // MARK: - Actions

    func onRetryTapped() {
        // Go back to camera
        router.pop()
    }

    func onLaterTapped() {
        // Go all the way back to Home
        router.pop(count: 2)
    }

    func onBackToHomeTapped() {
        router.pop(count: 2)
    }

    func onAlreadySolvedDismissed() {
        router.pop(count: 2)
    }

    func onErrorRetryTapped() {
        state = .loading
        verifyMission()
    }
}
