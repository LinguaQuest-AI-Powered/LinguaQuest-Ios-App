

import Foundation

final class MindReaderRepositoryImpl: MindReaderRepositoryProtocol {
    private let localDataSource: MindReaderLocalDataSourceProtocol
    private let remoteDataSource: MindReaderRemoteDataSourceProtocol?
    
    init(
        localDataSource: MindReaderLocalDataSourceProtocol,
        remoteDataSource: MindReaderRemoteDataSourceProtocol? = nil
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func getWorlds() async throws -> [MindReaderWorld] {
        if let remoteDS = remoteDataSource {
            do {
                let dtos = try await remoteDS.fetchWorlds()
                let domainWorlds: [MindReaderWorld] = dtos.compactMap { dto in
                    guard let id = dto.id, let name = dto.name else { return nil }
                    return MindReaderWorld(
                        id: id,
                        name: name,
                        icon: dto.icon ?? "🌐",
                        isUnlocked: dto.isUnlocked ?? true
                    )
                }
                if !domainWorlds.isEmpty {
                    return domainWorlds
                }
            } catch {
               
            }
        }
        
        let response = try await localDataSource.loadWorldsResponse()
        let localWorldDTOs: [MindReaderWorldDTO] = response.worlds ?? []
        let domainWorlds: [MindReaderWorld] = localWorldDTOs.compactMap { dto in
            guard let id = dto.id, let name = dto.name else { return nil }
            return MindReaderWorld(
                id: id,
                name: name,
                icon: dto.icon ?? "🌐",
                isUnlocked: dto.isUnlocked ?? true
            )
        }
        
        return domainWorlds
    }
    
    func getMatrixForWorld(worldId: String) async throws -> (words: [MindReaderWord], attributes: [QuestionAttribute]) {
        if let remoteDS = remoteDataSource {
            do {
                let matrixDTO = try await remoteDS.fetchWorldMatrix(worldId: worldId)
                return mapMatrixDTOToDomain(matrixDTO: matrixDTO, worldId: worldId)
            } catch {
                // Fallback to local data source
            }
        }
        
        let response = try await localDataSource.loadWorldsResponse()
        let matrices: [MindReaderWorldMatrixDTO] = response.matrices ?? []
        let targetMatrix = matrices.first(where: { $0.world?.id == worldId }) ?? matrices.first
        
        guard let matrix = targetMatrix else {
            return (words: [], attributes: [])
        }
        
        return mapMatrixDTOToDomain(matrixDTO: matrix, worldId: worldId)
    }
    
    func saveGameResult(worldId: String, result: TrapValidationResult) async throws {
        try await localDataSource.saveLocalResult(worldId: worldId, result: result)
        if let remoteDS = remoteDataSource {
            try? await remoteDS.submitResult(worldId: worldId, result: result)
        }
    }
    
    // MARK: - Private Mapper
    
    private func mapMatrixDTOToDomain(
        matrixDTO: MindReaderWorldMatrixDTO,
        worldId: String
    ) -> (words: [MindReaderWord], attributes: [QuestionAttribute]) {
        let rawWords: [MindReaderWordDTO] = matrixDTO.words ?? []
        let domainWords: [MindReaderWord] = rawWords.compactMap { dto in
            guard let id = dto.id,
                  let targetLang = dto.wordTargetLanguage,
                  let nativeLang = dto.wordNativeLanguage else {
                return nil
            }
            return MindReaderWord(
                id: id,
                wordTargetLanguage: targetLang,
                wordNativeLanguage: nativeLang,
                emoji: dto.emoji ?? "❓",
                categoryId: dto.categoryId ?? worldId,
                audioUrl: dto.audioUrl,
                attributeWeights: dto.attributeWeights ?? [:],
                probability: 0.0
            )
        }
        
        let rawAttributes: [QuestionAttributeDTO] = matrixDTO.attributes ?? []
        let domainAttributes: [QuestionAttribute] = rawAttributes.compactMap { dto in
            guard let id = dto.id,
                  let promptTarget = dto.promptTargetLanguage,
                  let promptNative = dto.promptNativeLanguage else {
                return nil
            }
            return QuestionAttribute(
                id: id,
                promptTargetLanguage: promptTarget,
                promptNativeLanguage: promptNative,
                audioUrl: dto.audioUrl,
                informationGain: 0.0
            )
        }
        
        return (words: domainWords, attributes: domainAttributes)
    }
}
