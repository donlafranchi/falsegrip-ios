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
    @IBOutlet weak var lblAge: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ageField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1

    }
    
    @objc func tapDone() {
        if let datePicker = self.ageField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.ageField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.ageField.resignFirstResponder() // 2-5
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.back()
    }
   
    @IBAction func didTapSave(_ sender: Any) {
        self.back()
    }
}
