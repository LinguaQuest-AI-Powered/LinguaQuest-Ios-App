

import Foundation

protocol MindReaderRepositoryProtocol: Sendable {
    func getWorlds() async throws -> [MindReaderWorld]
    func getMatrixForWorld(worldId: String) async throws -> (words: [MindReaderWord], attributes: [QuestionAttribute])
    func saveGameResult(worldId: String, result: TrapValidationResult) async throws
}
