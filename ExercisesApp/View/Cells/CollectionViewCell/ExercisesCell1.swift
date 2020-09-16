//
//  ExercisesCell1.swift
//  ExercisesApp
//
//  Created by developer on 9/8/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import Nuke

class ExercisesCell1: UICollectionViewCell {
    
    @IBOutlet weak var container: DropShadowView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblMuscle: UILabel!
    
    var exercise = Exercise()
    private let pipeline = ImagePipeline {
        $0.imageCache = nil
        $0.isDeduplicationEnabled = false
        $0.isProgressiveDecodingEnabled = true
    }
    
    func initCell(_ exercise: Exercise){
        
        self.exercise = exercise
        self.lblName.text = self.exercise.name
        self.lblMuscle.text = self.exercise.primary_muscle
        var options = ImageLoadingOptions()
        options.pipeline = pipeline
        options.transition = .fadeIn(duration: 0.25)

        let url = URL(string: "\(self.exercise.imagePath)")
        loadImage(
            with: ImageRequest(url: url!, processors: [_ProgressiveBlurImageProcessor()]),
            options: options,
            into: self.imgView!,
            progress: { _, completed, total in

            }
        )
        self.overlayView.isHidden = !self.exercise.isSelected
        self.imgCheck.isHidden = !self.exercise.isSelected
    }
}
