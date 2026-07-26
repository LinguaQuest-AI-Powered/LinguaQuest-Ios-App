//
//  GeminiLiveDTOs.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

// MARK: - Outgoing clientContent turnComplete
struct GeminiLiveClientTurnCompleteMessage: Encodable {
    let clientContent: GeminiLiveClientContentPayload
}

struct GeminiLiveClientContentPayload: Encodable {
    let turns: [GeminiLiveTurn]?
    let turnComplete: Bool

    enum CodingKeys: String, CodingKey {
        case turns
        case turnComplete = "turnComplete"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Only include `turns` if non-nil — Gemini rejects null values
        if let turns { try container.encode(turns, forKey: .turns) }
        try container.encode(turnComplete, forKey: .turnComplete)
    }
}

struct GeminiLiveTurn: Encodable {
    let role: String
    let parts: [GeminiLivePart]
}

// MARK: - Outgoing Client Setup Message
struct GeminiLiveSetupMessage: Encodable {
    let setup: GeminiLiveSetupPayload
}

struct GeminiLiveAudioTranscriptionConfig: Encodable {}

struct GeminiLiveSetupPayload: Encodable {
    let model: String
    let generationConfig: GeminiLiveGenerationConfig
    let systemInstruction: GeminiLiveSystemInstruction?
    let inputAudioTranscription: GeminiLiveAudioTranscriptionConfig?
    let outputAudioTranscription: GeminiLiveAudioTranscriptionConfig?
}

struct GeminiLiveGenerationConfig: Encodable {
    let responseModalities: [String]
}

struct GeminiLiveSystemInstruction: Encodable {
    let parts: [GeminiLivePart]
}

struct GeminiLivePart: Encodable {
    let text: String
}

// MARK: - Outgoing Realtime Audio Chunk
struct GeminiLiveRealtimeInputMessage: Encodable {
    let realtimeInput: GeminiLiveRealtimeInputPayload
}

struct GeminiLiveRealtimeInputPayload: Encodable {
    let mediaChunks: [GeminiLiveMediaChunk]
}

struct GeminiLiveMediaChunk: Encodable {
    let mimeType: String
    let data: String
}

// MARK: - Incoming Server Message
struct GeminiLiveServerMessage: Decodable {
    // Gemini sends `"setupComplete": {}` (an empty object) not a bool.
    // We only need to know it exists, so we decode it as a dummy struct.
    struct Empty: Decodable {}
    let setupComplete: Empty?
    let serverContent: GeminiLiveServerContent?
    let inputTranscription: GeminiLiveTranscription?
    let outputTranscription: GeminiLiveTranscription?
    let inputAudioTranscription: GeminiLiveTranscription?
    let outputAudioTranscription: GeminiLiveTranscription?
}

struct GeminiLiveTranscription: Decodable {
    let text: String?
}

struct GeminiLiveServerContent: Decodable {
    let modelTurn: GeminiLiveModelTurn?
    let turnComplete: Bool?
    let interrupted: Bool?
    let inputTranscription: GeminiLiveTranscription?
    let outputTranscription: GeminiLiveTranscription?
}

struct GeminiLiveModelTurn: Decodable {
    let parts: [GeminiLiveIncomingPart]?
}

struct GeminiLiveIncomingPart: Decodable {
    let text: String?
    let inlineData: GeminiLiveInlineData?
}

struct GeminiLiveInlineData: Decodable {
    let mimeType: String?
    let data: String?
}
