//
//  SetsModel.swift
//  ExercisesApp
//
//  Created by developer on 9/18/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class SetsModel: NSObject {

    var id = 0
    var reps = 0
    var workout = ""
    var exercise = ""
    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        
        id = json["id"] as? Int ?? 0
        reps = json["reps"] as? Int ?? 0
        workout = json["workout"] as? String ?? ""
        exercise = json["exercise"] as? String ?? ""
    }
}
