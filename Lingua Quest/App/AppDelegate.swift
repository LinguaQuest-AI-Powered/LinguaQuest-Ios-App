//
//  AppDelegate.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
     
        FirebaseApp.configure()
        
   
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification authorization
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error)")
            }
        }
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
        
        return true
    }
        // APNs Token to Firebase
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
        }
        
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            guard let token = fcmToken else { return }
            print("FCM Token: \(token)")
        
            // sendTokenToBackend(token)
        }
        
        // MARK: - UNUserNotificationCenterDelegate
        
        // 1. App is in Foreground
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Allow notification to show as Banner with sound even if app is in foreground
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .sound, .badge, .list])
            } else {
                completionHandler([.alert, .sound, .badge])
            }
        }
        
        // 2. Notification Tap
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            print("User tapped notification with info: \(userInfo)")
            
            // Post notification to allow SwiftUI components like RootView to handle routing
            NotificationCenter.default.post(
                name: NSNotification.Name("PushNotificationTapped"),
                object: nil,
                userInfo: userInfo
            )
            
            completionHandler()
        }
        
        // 3. Background & Silent Notifications
        func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            
            Messaging.messaging().appDidReceiveMessage(userInfo)
            completionHandler(.newData)
        }
}
