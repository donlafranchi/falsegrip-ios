//
//  WorkoutModel.swift
//  ExercisesApp
//
//  Created by developer on 9/16/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import SwiftyJSON

class WorkoutModel: NSObject {
    
    var id = ""
    var created = ""
    var modified = ""
    var datetime = ""
    var title = ""
    var body_weight: Float = 0.0
    var energy_level = 0
    var comments = ""
    var isToday = false
    var exercises = [Exercise]()
    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        id = json["id"] as? String ?? ""
        created = json["created"] as? String ?? ""
        modified = json["modified"] as? String ?? ""
        datetime = json["datetime"] as? String ?? ""
        title = json["title"] as? String ?? ""
        body_weight = json["body_weight"] as? Float ?? 0.0
        energy_level = json["energy_level"] as? Int ?? 0
        comments = json["comments"] as? String ?? ""
        
        let exercises = json["exercises"] as?  [[String: Any]] ?? []
        var exercisesList = [Exercise]()
        for item in exercises {
            exercisesList.append(Exercise(item))
        }
        self.exercises = exercisesList

    }
    
}
