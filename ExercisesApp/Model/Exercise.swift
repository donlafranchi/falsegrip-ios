//
//  Exercise.swift
//  ExercisesApp
//
//  Created by developer on 9/16/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class Exercise: NSObject {

    var id = ""
    var name = ""
    var desc = ""
    var imagePath = ""
    var gifPath = ""
    var videoPath = ""
    var creators = ""
    var equipment = ""
    var primary_muscle = ""
    var secondary_muscle = ""
    var isSelected = false

    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        
        id = json["id"] as? String ?? ""
        name = json["name"] as? String ?? ""
        desc = json["description"] as? String ?? ""
        imagePath = json["image"] as? String ?? ""
        gifPath = json["gif"] as? String ?? ""
        videoPath = json["video"] as? String ?? ""
        creators = json["creators"] as? String ?? ""
        equipment = json["equipment"] as? String ?? ""
        primary_muscle = json["primary_muscle"] as? String ?? ""
        secondary_muscle = json["secondary_muscle"] as? String ?? ""

    }
}
