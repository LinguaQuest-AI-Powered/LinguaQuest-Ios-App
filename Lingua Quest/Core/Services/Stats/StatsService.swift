//
//  StatsService.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 25/07/2026.
//

import Foundation
import Observation

protocol StatsServiceProtocol: AnyObject {
    var coins: Int { get }
    var xp: Int { get }
    var streakDays: Int { get }

    // Network-backed operations
    func fetchStats() async throws
    func addCoins(_ amount: Int) async throws
    func deductCoins(_ amount: Int) async throws
    func addXP(_ amount: Int) async throws
    func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws

    // Local-only updates (for when another endpoint returns new balances)
    func syncBalances(coins: Int?, xp: Int?, streakDays: Int?)
    
    // Clear state
    func resetAll()
}

@Observable
final class StatsService: StatsServiceProtocol {
    private let remoteDataSource: StatsRemoteDataSourceProtocol
    private var userPreferences: UserPreferencesProtocol
    
    var coins: Int {
        didSet { userPreferences.coinBalance = coins }
    }
    
    var xp: Int {
        didSet { userPreferences.xpBalance = xp }
    }
    
    var streakDays: Int {
        didSet { userPreferences.streakDays = streakDays }
    }
    
    init(remoteDataSource: StatsRemoteDataSourceProtocol, userPreferences: UserPreferencesProtocol) {
        self.remoteDataSource = remoteDataSource
        self.userPreferences = userPreferences
        self.coins = userPreferences.coinBalance
        self.xp = userPreferences.xpBalance
        self.streakDays = userPreferences.streakDays
    }
    
    func fetchStats() async throws {
        let response = try await remoteDataSource.getWallet()
        await MainActor.run {
            self.coins = response.data.coins ?? self.coins
            self.xp = response.data.xp ?? self.xp
        }
    }
    
    func addCoins(_ amount: Int) async throws {
        guard amount > 0 else { return }
        try await adjustWallet(coinsDelta: amount, xpDelta: 0)
    }
    
    func deductCoins(_ amount: Int) async throws {
        guard amount > 0 else { return }
        // Pre-check
        guard self.coins >= amount else { return } // Could throw a custom insufficient funds error here
        try await adjustWallet(coinsDelta: -amount, xpDelta: 0)
    }
    
    func addXP(_ amount: Int) async throws {
        guard amount > 0 else { return }
        try await adjustWallet(coinsDelta: 0, xpDelta: amount)
    }
    
    func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws {
        let response = try await remoteDataSource.adjustWallet(coinsDelta: coinsDelta, xpDelta: xpDelta)
        await MainActor.run {
            if let newCoins = response.data.coins {
                self.coins = newCoins
            } else {
                self.coins += coinsDelta
            }
            
            if let newXp = response.data.xp {
                self.xp = newXp
            } else {
                self.xp += xpDelta
            }
        }
    }
    
    func syncBalances(coins: Int?, xp: Int?, streakDays: Int? = nil) {
        if let coins = coins { self.coins = coins }
        if let xp = xp { self.xp = xp }
        if let streakDays = streakDays {
            self.streakDays = streakDays
        }
    }
    
    func resetAll() {
        self.coins = 0
        self.xp = 0
        self.streakDays = 0
    }
}
