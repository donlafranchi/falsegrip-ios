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
    var short_demo = ""
    var videoPath = ""
    var creators = ""
    var category = ""
    var muscle_category = ""
    var isSelected = false
    var trainer_obj = TrainerModel()
    var equipments_obj = [EquipmentModel]()
    var equipments = [String]()
    var trainer = ""
    var type = ""
    var difficulty_level = ""    
    var personal_record = 0
    var total_reps = 0
    var history = [String: Any]()
    var sets = [SetsModel]()

    
    override init() {
        super.init()
    }
    
    init(_ json: [String: Any]) {
        
        id = json["id"] as? String ?? ""
        name = json["name"] as? String ?? ""
        desc = json["description"] as? String ?? ""
        trainer_obj = TrainerModel(json["trainer_obj"] as? [String:Any] ?? [:])
        imagePath = json["image"] as? String ?? ""
        videoPath = json["instruction_video"] as? String ?? ""
        short_demo = json["short_demo"] as? String ?? ""
        creators = json["creators"] as? String ?? ""
        category = json["category"] as? String ?? ""
        muscle_category = json["muscle_category"] as? String ?? ""

        let sets = json["sets"] as?  [[String: Any]] ?? []
        var setsList = [SetsModel]()
        for item in sets {
            setsList.append(SetsModel(item))
        }
        self.sets = setsList
        
        let equipments = json["equipments_obj"] as?  [[String: Any]] ?? []
        var equipList = [EquipmentModel]()
        for item in equipments {
            equipList.append(EquipmentModel(item))
        }
        self.equipments_obj = equipList
        self.equipments = json["equipments"] as? [String] ?? []
        trainer = json["trainer"] as? String ?? ""
        type = json["type"] as? String ?? ""
        difficulty_level = json["difficulty_level"] as? String ?? ""
        personal_record = json["personal_record"] as? Int ?? 0
        total_reps = json["total_reps"] as? Int ?? 0
        history = json["history"] as? [String:Any] ?? [:]

    }
}
