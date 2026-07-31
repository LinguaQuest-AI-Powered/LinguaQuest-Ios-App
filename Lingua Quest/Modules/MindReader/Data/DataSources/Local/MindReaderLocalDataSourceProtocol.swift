

import Foundation

protocol MindReaderLocalDataSourceProtocol: Sendable {
    func loadWorldsResponse() async throws -> MindReaderWorldsResponseDTO
    func saveLocalResult(worldId: String, result: TrapValidationResult) async throws
}
