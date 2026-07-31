

import Foundation

struct InitializeGameUseCase: Sendable {
    private let repository: MindReaderRepositoryProtocol
    
    init(repository: MindReaderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(worldId: String) async throws -> MindReaderGameState {
        let worlds = try await repository.getWorlds()
        guard let world = worlds.first(where: { $0.id == worldId }) ?? worlds.first else {
            throw NSError(domain: "MindReader", code: 404, userInfo: [NSLocalizedDescriptionKey: "World not found"])
        }
        
        let (words, attributes) = try await repository.getMatrixForWorld(worldId: world.id)
        
        guard !words.isEmpty else {
            throw NSError(domain: "MindReader", code: 400, userInfo: [NSLocalizedDescriptionKey: "No words found for world"])
        }
        
        let initialProbability = 1.0 / Double(words.count)
        let initializedWords = words.map { word in
            var mutableWord = word
            mutableWord.probability = initialProbability
            return mutableWord
        }
        
        return MindReaderGameState(
            selectedWorld: world,
            candidateWords: initializedWords,
            availableAttributes: attributes,
            askedAttributeIds: [],
            answerHistory: [:],
            currentBestGuess: nil,
            isGuessThresholdReached: false
        )
    }
}
