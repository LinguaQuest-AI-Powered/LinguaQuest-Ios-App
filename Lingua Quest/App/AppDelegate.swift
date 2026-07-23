//
//  AppDelegate.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 23/07/2026.
//

import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Initialize DI Container
        _ = Resolver.shared
        
        // Set the Notification Center delegate so we can intercept taps
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // This function is triggered when the user taps on a local or remote notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // We ensure this runs on the main thread since we are mutating the UI state
        Task { @MainActor in
            let router = Resolver.shared.resolve(Router.self)
            
            // Pop the navigation stack all the way back to the RootView (.home)
            router.popToRoot()
            
            // Reset the tab view to the Home tab
            NotificationCenter.default.post(name: NSNotification.Name("ResetToHomeTab"), object: nil)
        }
        
        completionHandler()
    }
    
    // This allows the notification to show as a banner even if the app is already in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
