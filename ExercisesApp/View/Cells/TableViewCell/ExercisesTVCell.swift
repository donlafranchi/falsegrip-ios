//
//  ExercisesTVCell.swift
//  ExercisesApp
//
//  Created by developer on 9/10/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import Nuke

protocol ExercisesTVCellDelegate {
    func tapAddSet(_ exercise: Exercise)
}

class ExercisesTVCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPersonalReps: UILabel!
    @IBOutlet weak var lblSets: UILabel!
    @IBOutlet weak var lblReps: UILabel!
    
    var exercise = Exercise()
    private let pipeline = ImagePipeline {
        $0.imageCache = nil
        $0.isDeduplicationEnabled = false
        $0.isProgressiveDecodingEnabled = true
    }
    var delegate: ExercisesTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(_ exercise: Exercise){
        
        self.exercise = exercise
        self.lblName.text = self.exercise.name
        self.lblSets.text = "\(self.exercise.sets.count)"
        var reps = 0
        for item in self.exercise.sets {
            reps += item.reps
        }
        self.lblReps.text = "\(reps)"
        
        var options = ImageLoadingOptions()
        options.pipeline = pipeline
        options.transition = .fadeIn(duration: 0.25)

        let url = URL(string: "\(baseURL)\(self.exercise.imagePath)")
        loadImage(
            with: ImageRequest(url: url!, processors: [_ProgressiveBlurImageProcessor()]),
            options: options,
            into: self.imgView!,
            progress: { _, completed, total in

            }
        )
    }
    
    @IBAction func didTapAddSet(_ sender: Any) {
        delegate?.tapAddSet(self.exercise)
    }

}
