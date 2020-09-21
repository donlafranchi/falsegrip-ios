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
    var num = 0
    var reps = 0
    var workout = ""
    var exercise = ""
    var modifiedDate = ""
    var modified: Date?


    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        
        id = json["id"] as? Int ?? 0
        num = json["num"] as? Int ?? 0
        reps = json["reps"] as? Int ?? 0
        workout = json["workout"] as? String ?? ""
        exercise = json["exercise"] as? String ?? ""
        modifiedDate = json["modified"] as? String ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        modified = dateFormatter.date(from:modifiedDate)!
        

    }
}
