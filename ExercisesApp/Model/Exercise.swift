//
//  Exercise.swift
//  ExercisesApp
//
//  Created by developer on 9/16/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class Exercise: NSObject {

    var id = 0
    var name = ""
    var desc = ""
    var imagePath = ""
    var gifPath = ""
    var videoPath = ""

    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        

    }
}
