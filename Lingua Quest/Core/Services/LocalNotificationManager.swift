//
//  LocalNotificationManager.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation
import UserNotifications

final class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = LocalNotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        return try await center.requestAuthorization(options: options)
    }
    
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
    
    func scheduleDailyReminder(time: Date, repeatDays: [Int]) async {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing reminders to avoid duplicates
        cancelDailyReminder()
        
        // Request authorization if not yet granted
        let isAuthorized = try? await requestAuthorization()
        guard isAuthorized == true else { return }
        
        let content = UNMutableNotificationContent()
        content.title = L10n.Components.appName
        content.body = L10n.Auth.readyToContinue // Or create a specific string for the reminder body
        content.sound = .default
        
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        for weekday in repeatDays {
            var dateComponents = DateComponents()
            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            dateComponents.weekday = weekday // 1: Sunday, 2: Monday, ..., 7: Saturday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "dailyReminder-\(weekday)", content: content, trigger: trigger)
            
            do {
                try await center.add(request)
            } catch {
                print("Failed to schedule notification for weekday \(weekday): \(error.localizedDescription)")
            }
        }
    }
    
    func cancelDailyReminder() {
        let center = UNUserNotificationCenter.current()
        let identifiers = (1...7).map { "dailyReminder-\($0)" }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - Vocabulary Notifications
    func scheduleVocabularyNotification(word: String, meaning: String, wordId: UUID) {
        Task {
            let isAuthorized = try? await requestAuthorization()
            guard isAuthorized == true else { return }
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Learn: \(word)"
            content.body = meaning
            content.sound = .default
            content.userInfo = ["wordId": wordId.uuidString]
            
            // Trigger after a short delay (e.g., 5 seconds for demo/testing, or when entering background in real use case)
            // Note: In a real app, we might schedule this for when the app enters the background, or randomly during the day.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "vocabulary-\(wordId.uuidString)", content: content, trigger: trigger)
            
            do {
                try await center.add(request)
            } catch {
                print("Failed to schedule vocabulary notification: \(error)")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let wordIdString = userInfo["wordId"] as? String, let wordId = UUID(uuidString: wordIdString) {
            NotificationCenter.default.post(name: NSNotification.Name("VocabularyNotificationTapped"), object: nil, userInfo: ["wordId": wordId])
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
