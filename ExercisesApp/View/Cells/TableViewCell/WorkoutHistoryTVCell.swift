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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        updateOverlay(selected)
//    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateOverlay(highlighted)
    }
    
    
    func updateOverlay(_ isSelected: Bool){
        
        self.overlay.alpha = isSelected ? 1 : 0
        
    }

}
