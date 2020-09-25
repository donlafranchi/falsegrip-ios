//
//  TrainerModel.swift
//  ExercisesApp
//
//  Created by developer on 9/26/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class TrainerModel: NSObject {

    var name = ""
    var website_url = ""
    var instagram_url = ""
    var youtube_url = ""
    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        
        name = json["name"] as? String ?? ""
        website_url = json["website_url"] as? String ?? ""
        instagram_url = json["instagram_url"] as? String ?? ""
        youtube_url = json["youtube_url"] as? String ?? ""
        
    }
}
