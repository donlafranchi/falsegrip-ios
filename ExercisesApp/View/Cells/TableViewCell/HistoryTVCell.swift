//
//  HistoryTVCell.swift
//  ExercisesApp
//
//  Created by developer on 9/9/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class HistoryTVCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblWeekday: UILabel!
    @IBOutlet weak var lblReps: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
