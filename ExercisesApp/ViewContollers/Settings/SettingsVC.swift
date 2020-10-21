//
//  SettingsVC.swift
//  ExercisesApp
//
//  Created by developer on 10/21/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import AYPopupPickerView

class SettingsVC: UIViewController {


    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var reminderView: UIView!
    
    let popupDatePickerView = AYPopupDatePickerView()
    var reminderTime = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
//        timeField.delegate = self
        
        popupDatePickerView.datePickerView.datePickerMode = .time
        popupDatePickerView.datePickerView.locale = .current
        popupDatePickerView.headerView.backgroundColor = BACKGROUND_COLOR
        popupDatePickerView.doneButton.setTitleColor(COLOR3, for: .normal)
        popupDatePickerView.cancelButton.setTitleColor(.gray, for: .normal)
        popupDatePickerView.datePickerView.setValue(MAIN_COLOR, forKeyPath: "textColor")
        
        if #available(iOS 14, *) {
            popupDatePickerView.datePickerView.preferredDatePickerStyle = .wheels
            popupDatePickerView.datePickerView.sizeToFit()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        self.timeBtn.setTitle(formatter.string(from: reminderTime), for: .normal)
    }


    @IBAction func didTapBack(_ sender: Any) {
        self.back()
    }
    
    @IBAction func didTapTime(_ sender: Any) {
        

        popupDatePickerView.display(defaultDate: reminderTime, doneHandler: { date in
            print(date)
            self.reminderTime = date
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            self.timeBtn.setTitle(formatter.string(from: date), for: .normal)
        })
    }
    
    @IBAction func didTapContactUs(_ sender: Any) {
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
    }
    
}

