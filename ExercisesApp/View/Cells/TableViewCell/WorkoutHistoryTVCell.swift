//
//  WorkoutHistoryTVCell.swift
//  ExercisesApp
//
//  Created by developer on 9/5/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class WorkoutHistoryTVCell: UITableViewCell {

    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    var workout = WorkoutModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateOverlay(highlighted)
    }
    
    
    func updateOverlay(_ isSelected: Bool){
        
        self.overlay.alpha = isSelected ? 1 : 0
        
    }
    
    func initCell( _ workout: WorkoutModel){
        
        self.workout = workout
        
        self.lblSub.isHidden = workout.isToday
        if self.workout.isToday {
            self.lblMain.text = "What will you work on today?"
        }else{
            
            let categories = self.workout.title.split(separator: "/")
            var cats : [String] = []
            for item in categories {
                if !cats.contains(String(item)) {
                    cats.append(String(item))
                }
            }
            var title = cats.joined(separator: "/")
            if cats.count == 5 {
                title = "Full Body"
            }
            
//            var categories = [String]()
//            for item in self.workout.exercises {
//
//                if !categories.contains(item.category) {
//                    categories.append(item.category)
//                }
//            }
//            var title = categories.joined(separator: "/")
//            if categories.count == 5 {
//                title = "Full Body"
//            }
            
            self.lblMain.text = title
        }
        
        self.lblSub.isHidden = self.workout.exercises.count == 0
        
        if self.workout.exercises.count > 0 {
            var names = [String]()
            for item in self.workout.exercises {
                
                if !names.contains(item.name) {
                    names.append(item.name)
                }
            }
            self.lblSub.text = names.joined(separator: ", ")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:self.workout.datetime)!
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: date)
       
        self.lblDay.text = day
        self.lblMonth.text = weekDay.uppercased()
    }

}
