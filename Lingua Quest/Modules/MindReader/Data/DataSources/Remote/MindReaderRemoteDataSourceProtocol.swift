

import Foundation

protocol MindReaderRemoteDataSourceProtocol: Sendable {
    func fetchWorlds() async throws -> [MindReaderWorldDTO]
    func fetchWorldMatrix(worldId: String) async throws -> MindReaderWorldMatrixDTO
    func submitResult(worldId: String, result: TrapValidationResult) async throws
}
