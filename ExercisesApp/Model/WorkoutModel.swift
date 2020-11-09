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
    var body_weight: Double = 0.0
    var energy_level = 0
    var comments = ""
    var order = ""
    var isToday = false
    var isCreated = false
    var exercises = [Exercise]()
    var exercise_notes: [String:Any] = [:]
    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        id = json["id"] as? String ?? ""
        created = json["created"] as? String ?? ""
        modified = json["modified"] as? String ?? ""
        datetime = json["datetime"] as? String ?? ""
        title = json["title"] as? String ?? ""
        body_weight = json["body_weight"] as? Double ?? 0.0
        energy_level = json["energy_level"] as? Int ?? 0
        comments = json["comments"] as? String ?? ""
        order = json["order"] as? String ?? ""
        let exercises = json["exercises_obj"] as?  [[String: Any]] ?? []
        var exercisesList = [Exercise]()
        for item in exercises {
            exercisesList.append(Exercise(item))
        }
        self.exercises = exercisesList

        let jsonStr = json["exercise_notes"] as? String ?? ""
        let data = Data(jsonStr.utf8)

        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                exercise_notes = json
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
}
