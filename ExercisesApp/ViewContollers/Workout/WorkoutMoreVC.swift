//
//  WorkoutMoreVC.swift
//  ExercisesApp
//
//  Created by developer on 10/2/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

protocol WorkoutMoreVCDelegate {
    func tapClose()
    func tapEdit()
    func tapRemove()
    func tapSort()
}

class WorkoutMoreVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    var delegate: WorkoutMoreVCDelegate?
    var workoutTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lblTitle.text = workoutTitle
    }
    

    @IBAction func didTapClose(_ sender: Any) {
        delegate?.tapClose()
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        delegate?.tapEdit()
    }
    
    @IBAction func didTapRemove(_ sender: Any) {
        delegate?.tapRemove()
    }
    
    @IBAction func didTapSort(_ sender: Any) {
        delegate?.tapSort()
    }
}
