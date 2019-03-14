//
//  UserNotificationManager.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 23/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UserNotifications

class UserNotificationManager: NSObject {
    
    static let shared = UserNotificationManager()
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
    }
    
    func addNotification(title: String, body: String) {
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = title
        content.body = body
        
        let request = UNNotificationRequest(
            identifier: "trackmoneyNotification",
            content: content,
            trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
    }
    
}

extension UserNotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
