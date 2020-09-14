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
}

class UserInfo: NSObject {
    
    static let shared = UserInfo()
    
    var id = 0
    var appleID: String = ""
    var username: String = ""
    var token: String = ""
    
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
        }
    }
    
}
