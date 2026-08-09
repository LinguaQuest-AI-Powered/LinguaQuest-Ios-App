//
//  ProfileDTO.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let success: Bool
    let data: ProfileDataDTO
}

// MARK: - Update Profile
struct UpdateProfileRequestDTO: Encodable {
    let username: String
}

struct UpdateProfileResponseDTO: Decodable {
    let success: Bool
    let data: UpdateProfileDataDTO
}

struct UpdateProfileDataDTO: Decodable {
    let id: Int
    let username: String
}

struct UploadPhotoResponseDTO: Decodable {
    let success: Bool
    let data: UploadPhotoDataDTO
}

struct UploadPhotoDataDTO: Decodable {
    let photoUrl: String
}

// MARK: - Change Password
struct ChangePasswordRequestDTO: Encodable {
    let oldPassword: String
    let newPassword: String
}

struct ChangePasswordResponseDTO: Decodable {
    let success: Bool
    let data: ChangePasswordDataDTO
}

struct ChangePasswordDataDTO: Decodable {
    let status: String
}

struct ProfileNativeLanguageDTO: Decodable {
    let id: Int?
    let name: String
    let code: String?
    let imageUrl: String?
}

enum FlexibleNativeLanguageDTO: Decodable {
    case string(String)
    case object(ProfileNativeLanguageDTO)
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            if let str = try? container.decode(String.self) {
                self = .string(str)
                return
            }
            if let obj = try? container.decode(ProfileNativeLanguageDTO.self) {
                self = .object(obj)
                return
            }
        }
        throw DecodingError.typeMismatch(FlexibleNativeLanguageDTO.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Dictionary for nativeLanguage"))
    }
    
    var name: String {
        switch self {
        case .string(let s): return s
        case .object(let o): return o.name
        }
    }
}


struct ProfileDataDTO: Decodable {
    let id: Int
    let email: String
    let username: String?
    let nativeLanguage: FlexibleNativeLanguageDTO?
    let photoUrl: String?
    let level: Int?
    let stats: ProfileStatsDTO?
    let currentLanguageJourney: ProfileJourneyDTO?
    let achievements: [ProfileAchievementPreviewDTO]?
    let leaderboard: [ProfileLeaderboardPreviewDTO]?

    // Keep computed wrappers so the repository code doesn't need to change
    var achievementsSummary: ProfileAchievementsSummaryDTO? {
        guard let achievements else { return nil }
        return ProfileAchievementsSummaryDTO(
            earnedCount: achievements.filter { $0.status == "UNLOCKED" }.count,
            totalCount: achievements.count,
            preview: achievements
        )
    }

    var leaderboardSummary: ProfileLeaderboardSummaryDTO? {
        guard let leaderboard else { return nil }
        // find current user's rank, fall back to 0
        let myRank = leaderboard.first(where: { $0.isCurrentUser })?.rank ?? 0
        return ProfileLeaderboardSummaryDTO(myRank: myRank, preview: leaderboard)
    }
}

struct ProfileStatsDTO: Decodable {
    let coins: Int
    let totalXp: Int
    let streakDays: Int
    let worldsCount: Int
}

struct ProfileJourneyDTO: Decodable {
    let languageId: Int
    let name: String
    let code: String
    let level: Int
    let journeyLabel: String
    let currentXp: Int
    let nextMilestoneXp: Int
}

struct ProfileAchievementsSummaryDTO {
    let earnedCount: Int
    let totalCount: Int
    let preview: [ProfileAchievementPreviewDTO]
}

struct ProfileAchievementPreviewDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let iconUrl: String?
    let status: String
    let progressPercent: Int
    let xpReward: Int?
    let rewardXp: Int?
    let coinsReward: Int?
    let rewardCoins: Int?
    let earnedAt: String?
    let earnedDate: String?
}

struct ProfileLeaderboardSummaryDTO {
    let myRank: Int
    let preview: [ProfileLeaderboardPreviewDTO]
}

struct ProfileLeaderboardPreviewDTO: Decodable {
    let rank: Int
    let userId: Int
    let username: String
    let photoUrl: String?
    let level: Int
    let xp: Int
    let isCurrentUser: Bool
}
