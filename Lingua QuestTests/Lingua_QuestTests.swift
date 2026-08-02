//
//  Lingua_QuestTests.swift
//  Lingua QuestTests
//
//  Created by siam on 14/07/2026.
//

import XCTest
@testable import Lingua_Quest

final class Lingua_QuestTests: XCTestCase {

    class MockMindReaderRepository: MindReaderRepositoryProtocol {
        var mockDecision: AIGameDecision?
        var mockError: Error?
        var mockHonestyVerdict: HonestyVerdict?
        
        func fetchCategories() -> [GameCategory] {
            return []
        }
        
        func requestNextStep(category: GameCategory, history: [GameTurn]) async throws -> AIGameDecision {
            if let error = mockError { throw error }
            if let decision = mockDecision { return decision }
            fatalError("No mock provided")
        }
        
        func requestQuizChoices(category: GameCategory, correctWord: String) async throws -> [QuizChoice] {
            return []
        }
        
        func verifyHonesty(category: GameCategory, history: [GameTurn], claimedWord: String) async throws -> HonestyVerdict {
            if let error = mockError { throw error }
            if let verdict = mockHonestyVerdict { return verdict }
            fatalError("No mock provided")
        }
    }
    
    var mockRepository: MockMindReaderRepository!
    var requestNextStepUseCase: RequestNextGameStepUseCase!
    var verifyHonestyUseCase: VerifyHonestyUseCase!
    let dummyCategory = GameCategory(id: "1", key: "food", nativeName: "طعام", targetName: "Food", emoji: "🍎", promptContext: "Food items")
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMindReaderRepository()
        requestNextStepUseCase = RequestNextGameStepUseCase(repository: mockRepository)
        verifyHonestyUseCase = VerifyHonestyUseCase(repository: mockRepository)
    }
    
    func testRequestNextStepReturnsQuestion() async throws {
        // Arrange
        let expectedDecision = AIGameDecision.question(targetText: "Is it sweet?", nativeText: "هل هو حلو؟")
        mockRepository.mockDecision = expectedDecision
        
        // Act
        let decision = try await requestNextStepUseCase.execute(category: dummyCategory, history: [])
        
        // Assert
        switch decision {
        case .question(let target, let native):
            XCTAssertEqual(target, "Is it sweet?")
            XCTAssertEqual(native, "هل هو حلو؟")
        case .guess:
            XCTFail("Expected question but got guess")
        }
    }
    
    func testRequestNextStepReturnsGuess() async throws {
        // Arrange
        let expectedDecision = AIGameDecision.guess(word: "Apple", translation: "تفاحة", emoji: "🍎")
        mockRepository.mockDecision = expectedDecision
        
        // Act
        let decision = try await requestNextStepUseCase.execute(category: dummyCategory, history: [])
        
        // Assert
        switch decision {
        case .question:
            XCTFail("Expected guess but got question")
        case .guess(let word, let trans, let emoji):
            XCTAssertEqual(word, "Apple")
            XCTAssertEqual(trans, "تفاحة")
            XCTAssertEqual(emoji, "🍎")
        }
    }
    
    func testVerifyHonestyReturnsHonest() async throws {
        // Arrange
        let expectedVerdict = HonestyVerdict(isHonest: true, explanation: "Good job")
        mockRepository.mockHonestyVerdict = expectedVerdict
        
        // Act
        let verdict = try await verifyHonestyUseCase.execute(category: dummyCategory, history: [], claimedWord: "Apple")
        
        // Assert
        XCTAssertTrue(verdict.isHonest)
        XCTAssertEqual(verdict.explanation, "Good job")
    }
    
    func testVerifyHonestyReturnsDishonest() async throws {
        // Arrange
        let expectedVerdict = HonestyVerdict(isHonest: false, explanation: "You lied")
        mockRepository.mockHonestyVerdict = expectedVerdict
        
        // Act
        let verdict = try await verifyHonestyUseCase.execute(category: dummyCategory, history: [], claimedWord: "Car")
        
        // Assert
        XCTAssertFalse(verdict.isHonest)
        XCTAssertEqual(verdict.explanation, "You lied")
    }
    
    func testMapperMissingGuessWordThrowsError() {
        // Arrange
        let dto = AkinatorStepResponseDTO(
            type: "guess",
            questionTargetText: nil,
            questionNativeText: nil,
            guessWord: nil, // Missing guess word!
            guessTranslation: "تفاحة",
            guessEmoji: "🍎"
        )
        
        // Act & Assert
        XCTAssertThrowsError(try dto.toDomain()) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "MindReaderMapper")
            XCTAssertEqual(nsError.code, 0)
        }
    }
}
