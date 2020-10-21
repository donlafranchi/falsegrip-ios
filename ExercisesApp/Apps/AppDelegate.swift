//
//  AppDelegate.swift
//  ExercisesApp
//
//  Created by developer on 9/5/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AuthenticationServices
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        Thread.sleep(forTimeInterval: 3.0)
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (accepted, error) in
            
            if accepted {
                self.removeNotifications()
                self.setNotifications()
            }
            
        }
        UNUserNotificationCenter.current().delegate = self
        
        
        window = UIWindow(frame: UIScreen.main.bounds)

        for family in UIFont.familyNames {
            print("\(family)")

            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }   
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

      completionHandler([.alert,.sound,.badge])
    }

    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void) {

      completionHandler()
    }

    
    func removeNotifications(){
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func setNotifications(){
        
        if !UserInfo.shared.isReminder {
            return
        }
        
        if UserInfo.shared.reminderTime == nil {
            return
        }
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's exercise time."
        content.categoryIdentifier = "alarm"
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: UserInfo.shared.reminderTime!)
        dateComponents.minute = calendar.component(.minute, from: UserInfo.shared.reminderTime!)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        center.add(request)
        
    }
}

