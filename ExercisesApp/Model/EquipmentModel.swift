//
//  EquipmentModel.swift
//  ExercisesApp
//
//  Created by developer on 9/26/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class EquipmentModel: NSObject {

    var id = ""
    var name = ""
    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        id = json["id"] as? String ?? ""
        name = json["name"] as? String ?? ""
    }
}
