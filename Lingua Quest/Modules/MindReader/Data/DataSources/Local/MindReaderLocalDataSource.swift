

import Foundation

final class MindReaderLocalDataSource: MindReaderLocalDataSourceProtocol {
    private let bundle: Bundle
    private let jsonFilename: String
    
    init(bundle: Bundle = .main, jsonFilename: String = "MindReaderWorlds") {
        self.bundle = bundle
        self.jsonFilename = jsonFilename
    }
    
    func loadWorldsResponse() async throws -> MindReaderWorldsResponseDTO {
        guard let url = bundle.url(forResource: jsonFilename, withExtension: "json") else {
            
            return MindReaderLocalDataSource.embeddedDefaultData
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(MindReaderWorldsResponseDTO.self, from: data)
        } catch {
            return MindReaderLocalDataSource.embeddedDefaultData
        }
    }
    
    func saveLocalResult(worldId: String, result: TrapValidationResult) async throws {
        
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "MindReader_LastPlayed_\(worldId)")
    }
    
    // MARK: - Offline Embedded Fallback Data
    
    private static var embeddedDefaultData: MindReaderWorldsResponseDTO {
        let kitchenWorld = MindReaderWorldDTO(id: "kitchen", name: "Kitchen", icon: "🍳", isUnlocked: true)
        let natureWorld = MindReaderWorldDTO(id: "nature", name: "Nature", icon: "🌿", isUnlocked: true)
        
        let kitchenWords: [MindReaderWordDTO] = [
            MindReaderWordDTO(
                id: "w1",
                wordTargetLanguage: "Manzana",
                wordNativeLanguage: "Apple",
                emoji: "🍎",
                categoryId: "kitchen",
                audioUrl: nil,
                attributeWeights: ["is_red": 1.0, "is_fruit": 1.0, "is_sweet": 0.9, "is_liquid": 0.0]
            ),
            MindReaderWordDTO(
                id: "w2",
                wordTargetLanguage: "Cuchillo",
                wordNativeLanguage: "Knife",
                emoji: "🔪",
                categoryId: "kitchen",
                audioUrl: nil,
                attributeWeights: ["is_red": 0.0, "is_fruit": 0.0, "is_sweet": 0.0, "is_liquid": 0.0]
            ),
            MindReaderWordDTO(
                id: "w3",
                wordTargetLanguage: "Leche",
                wordNativeLanguage: "Milk",
                emoji: "🥛",
                categoryId: "kitchen",
                audioUrl: nil,
                attributeWeights: ["is_red": 0.0, "is_fruit": 0.0, "is_sweet": 0.3, "is_liquid": 1.0]
            ),
            MindReaderWordDTO(
                id: "w4",
                wordTargetLanguage: "Fresa",
                wordNativeLanguage: "Strawberry",
                emoji: "🍓",
                categoryId: "kitchen",
                audioUrl: nil,
                attributeWeights: ["is_red": 1.0, "is_fruit": 1.0, "is_sweet": 1.0, "is_liquid": 0.0]
            )
        ]
        
        let kitchenAttributes: [QuestionAttributeDTO] = [
            QuestionAttributeDTO(id: "is_red", promptTargetLanguage: "¿Es de color rojo?", promptNativeLanguage: "Is it red?", audioUrl: nil),
            QuestionAttributeDTO(id: "is_fruit", promptTargetLanguage: "¿Es una fruta?", promptNativeLanguage: "Is it a fruit?", audioUrl: nil),
            QuestionAttributeDTO(id: "is_sweet", promptTargetLanguage: "¿Es dulce?", promptNativeLanguage: "Is it sweet?", audioUrl: nil),
            QuestionAttributeDTO(id: "is_liquid", promptTargetLanguage: "¿Es un líquido?", promptNativeLanguage: "Is it a liquid?", audioUrl: nil)
        ]
        
        let kitchenMatrix = MindReaderWorldMatrixDTO(
            world: kitchenWorld,
            words: kitchenWords,
            attributes: kitchenAttributes
        )
        
        let natureWords: [MindReaderWordDTO] = [
            MindReaderWordDTO(
                id: "w5",
                wordTargetLanguage: "Árbol",
                wordNativeLanguage: "Tree",
                emoji: "🌳",
                categoryId: "nature",
                audioUrl: nil,
                attributeWeights: ["is_green": 1.0, "is_animal": 0.0, "can_fly": 0.0]
            ),
            MindReaderWordDTO(
                id: "w6",
                wordTargetLanguage: "Pájaro",
                wordNativeLanguage: "Bird",
                emoji: "🐦",
                categoryId: "nature",
                audioUrl: nil,
                attributeWeights: ["is_green": 0.2, "is_animal": 1.0, "can_fly": 1.0]
            )
        ]
        
        let natureAttributes: [QuestionAttributeDTO] = [
            QuestionAttributeDTO(id: "is_green", promptTargetLanguage: "¿Es de color verde?", promptNativeLanguage: "Is it green?", audioUrl: nil),
            QuestionAttributeDTO(id: "is_animal", promptTargetLanguage: "¿Es un animal?", promptNativeLanguage: "Is it an animal?", audioUrl: nil),
            QuestionAttributeDTO(id: "can_fly", promptTargetLanguage: "¿Puede volar?", promptNativeLanguage: "Can it fly?", audioUrl: nil)
        ]
        
        let natureMatrix = MindReaderWorldMatrixDTO(
            world: natureWorld,
            words: natureWords,
            attributes: natureAttributes
        )
        
        return MindReaderWorldsResponseDTO(
            worlds: [kitchenWorld, natureWorld],
            matrices: [kitchenMatrix, natureMatrix]
        )
    }
}
