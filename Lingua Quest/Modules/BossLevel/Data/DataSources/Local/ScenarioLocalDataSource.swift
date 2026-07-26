//
//  ScenarioLocalDataSource.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

final class ScenarioLocalDataSource {
    func loadScenarios() throws -> [BossScenario] {
        let appLanguage = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        let fileName = appLanguage == "ar" ? "scenarios_ar" : "scenarios_en"
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "ScenarioLocalDataSource", code: 404, userInfo: [NSLocalizedDescriptionKey: "Scenarios file not found: \(fileName).json"])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([BossScenario].self, from: data)
    }
}
