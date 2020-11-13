//
//  ProfileModel.swift
//  ExercisesApp
//
//  Created by developer on 11/14/20.
//

import UIKit

class ProfileModel: NSObject {

    var id = ""
    var first_name = ""
    var birthday = ""
    var weight = 0
    var city = ""
    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        
        id = json["id"] as? String ?? ""
        first_name = json["first_name"] as? String ?? ""
        birthday = json["birthday"] as? String ?? ""
        weight = json["weight"] as? Int ?? 0
        city = json["city"] as? String ?? ""
    }
}
