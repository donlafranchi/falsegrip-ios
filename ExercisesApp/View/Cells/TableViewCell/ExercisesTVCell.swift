//
//  ExercisesTVCell.swift
//  ExercisesApp
//
//  Created by developer on 9/10/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import Nuke
import SDWebImage

protocol ExercisesTVCellDelegate {
    func tapAddSet(_ exercise: Exercise)
    func tapExercise(_ exercise: Exercise)
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
        
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imgView.addGestureRecognizer(imgTap)
        
        let lblTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        lblName.addGestureRecognizer(lblTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.tapExercise(self.exercise)
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
        
//        var options = ImageLoadingOptions()
//        options.pipeline = pipeline
//        options.placeholder = UIImage(named: "placeholder")
//        options.transition = .fadeIn(duration: 0.25)

        let url = URL(string: "\(baseURL)\(self.exercise.imagePath)")
//        loadImage(
//            with: ImageRequest(url: url!, processors: [_ProgressiveBlurImageProcessor()]),
//            options: options,
//            into: self.imgView!,
//            progress: { _, completed, total in
//
//            }
//        )
        self.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
    
    @IBAction func didTapAddSet(_ sender: Any) {
        delegate?.tapAddSet(self.exercise)
    }
    
    

}
