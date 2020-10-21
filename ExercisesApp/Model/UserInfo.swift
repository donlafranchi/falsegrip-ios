//
//  UserInfo.swift
//  SafeRole
//
//  Created by Mac on 5/24/20.
//  Copyright © 2020 Modvision Inc. All rights reserved.
//

import Foundation

enum UserField {
    case appleID
    case token
    case name
    case unit
    case showOnboarding1
    case showOnboarding2
    case showOnboarding3
    case showOnboarding4
    case isReminder
    case reminderTime

}

class UserInfo: NSObject {
    
    static let shared = UserInfo()
    
    var id = 0
    var appleID: String = ""
    var username: String = ""
    var token: String = ""
    var unit: Int = 0
    var showOnboarding1: Bool = false
    var showOnboarding2: Bool = false
    var showOnboarding3: Bool = false
    var showOnboarding4: Bool = false
    var isReminder: Bool = true
    var reminderTime: Date?



    override init() {
        super.init()
        
        initialize()
    }
    
    func initialize() {
        let defaults = UserDefaults.standard
        if let appleId = defaults.string(forKey: "appleID") {
            appleID = appleId
        }
        if let userName = defaults.string(forKey: "name") {
            username = userName
        }
        if let token = defaults.string(forKey: "token") {
            self.token = token
        }
        self.unit = defaults.integer(forKey: "unit")
        
        self.showOnboarding1 = defaults.bool(forKey: "showOnboarding1")
        self.showOnboarding2 = defaults.bool(forKey: "showOnboarding2")
        self.showOnboarding3 = defaults.bool(forKey: "showOnboarding3")
        self.showOnboarding4 = defaults.bool(forKey: "showOnboarding4")
        self.isReminder = defaults.bool(forKey: "isReminder")
        
        if let reminderTime = defaults.object(forKey: "reminderTime") {
            self.reminderTime = (reminderTime as! Date)
        }

    }
    
    func setUserInfo(_ key: UserField, value: Any) {
        let defaults = UserDefaults.standard
        
        switch key {
        case .appleID:
            appleID = value as? String ?? ""
            defaults.set(appleID, forKey: "appleID")
        case .name:
            username = value as? String ?? ""
            defaults.set(username, forKey: "name")
        case .token:
            token = value as? String ?? ""
            defaults.set(token, forKey: "token")
        case .unit:
            unit = value as? Int ?? 0
            defaults.set(unit, forKey: "unit")
        case .showOnboarding1:
            showOnboarding1 = value as? Bool ?? false
            defaults.set(showOnboarding1, forKey: "showOnboarding1")
        case .showOnboarding2:
            showOnboarding2 = value as? Bool ?? false
            defaults.set(showOnboarding2, forKey: "showOnboarding2")
        case .showOnboarding3:
            showOnboarding3 = value as? Bool ?? false
            defaults.set(showOnboarding3, forKey: "showOnboarding3")
        case .showOnboarding4:
            showOnboarding4 = value as? Bool ?? false
            defaults.set(showOnboarding4, forKey: "showOnboarding4")
        case .isReminder:
            isReminder = value as? Bool ?? true
            defaults.set(isReminder, forKey: "isReminder")
        case .reminderTime:
            reminderTime = (value as! Date)
            defaults.set(reminderTime, forKey: "reminderTime")
        }
        
        
    }
    
}
