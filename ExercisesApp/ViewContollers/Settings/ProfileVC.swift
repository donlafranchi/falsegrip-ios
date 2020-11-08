//
//  ProfileVC.swift
//  ExercisesApp
//
//  Created by developer on 11/9/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import MaterialTextField

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameField: MFTextField!
    @IBOutlet weak var ageField: MFTextField!
    @IBOutlet weak var weightField: MFTextField!
    @IBOutlet weak var cityField: MFTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapBack(_ sender: Any) {
        self.back()
    }
   
    @IBAction func didTapSave(_ sender: Any) {
        self.back()
    }
}
