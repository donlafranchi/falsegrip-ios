//
//  StatusVC.swift
//  ExercisesApp
//
//  Created by developer on 9/11/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import GrowingTextView
import StepSlider

protocol StatusVCDelegate {
    func saveNote(_ workout: WorkoutModel)
}

class StatusVC: UIViewController {

    @IBOutlet weak var energySlider: StepSlider!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var notesTextView: GrowingTextView!
    @IBOutlet weak var unitDropDown: DropDown!
    var minusTimer: Timer?
    var plusTimer: Timer?
    var workout = WorkoutModel()
    var delegate : StatusVCDelegate?
    var units = ["kg","lb"]
    var selectedUnit = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        initDropDown()
//        self.weightField.text = "\(self.workout.body_weight)"
//        self.energySlider.index = UInt(self.workout.energy_level)
        self.notesTextView.text = self.workout.comments
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.swipeBack?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.swipeBack?.isEnabled = true
    }
    
    func initDropDown(){
        unitDropDown.optionArray = units
        unitDropDown.selectedIndex = 0
        unitDropDown.isSearchEnable = false
        unitDropDown.selectedRowColor = .clear
        unitDropDown.text = units[UserInfo.shared.unit]
       
        unitDropDown.didSelect { (unit, index, id) in
            UserInfo.shared.setUserInfo(.unit, value: index)
            self.selectedUnit = index
        }
    }

    func startMinusTimer(){
         minusTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(minusPress), userInfo: nil, repeats: true)
    }
    
    func startPlusTimer(){
        plusTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(plusPress), userInfo: nil, repeats: true)
    }
    
    @objc func minusPress() {
        if self.workout.body_weight == 0 {
            minusTimer?.invalidate()
            return
        }
        
        self.workout.body_weight -= 0.5
        self.weightField.text = "\(self.workout.body_weight)"
    }
    
    @objc func plusPress() {
        self.workout.body_weight += 0.5
        self.weightField.text = "\(self.workout.body_weight)"
    }

    @IBAction func didTapBack(_ sender: Any) {
         back()
    }
       
    @IBAction func didChangeEnergy(_ sender: StepSlider) {
        print(sender.index)
        self.workout.energy_level = Int(sender.index)
    }
    
    
    @IBAction func didTapMinuse(_ sender: Any) {
        
        if self.workout.body_weight == 0 {
            return
        }
        
        self.workout.body_weight -= 0.5
        self.weightField.text = "\(self.workout.body_weight)"
    }
    
    @IBAction func didTapPlus(_ sender: Any) {
        
        self.workout.body_weight += 0.5
        self.weightField.text = "\(self.workout.body_weight)"
        
    }
    
    @IBAction func longPressMinus(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            startMinusTimer()
        case .cancelled, .ended:
            minusTimer?.invalidate()
        default:
            break
        }
      
    }
    
    @IBAction func longPressPlus(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            startPlusTimer()
        case .cancelled, .ended:
            plusTimer?.invalidate()
        default:
            break
        }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        
        UserInfo.shared.setUserInfo(.unit, value: selectedUnit)
        self.workout.comments = notesTextView.text
        self.showHUD()
        
        let params = [
            "body_weight": self.workout.body_weight,
            "energy_level": self.workout.energy_level,
            "comments": self.workout.comments] as [String : Any]
        
        ApiService.updateWorkout2(id: self.workout.id,params: params) { (success, data) in
            self.dismissHUD()
            if success {
                self.delegate?.saveNote(self.workout)
                self.back()
            }else{
                self.showFailureAlert()
            }
        }        
        
    }
    
}

extension StatusVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = textField.text,
            let textRange = Range(range, in: str) {
            let updatedText = str.replacingCharacters(in: textRange,
                                                       with: string)
            
            if updatedText.count > 8 {
                return false
            }
            
            if updatedText.isEmpty {
                self.workout.body_weight = 0.0
            }else{
                var count = 0
                for item in updatedText {
                    if item == "." {
                        count += 1
                    }
                }
                if count > 1 {
                    return false
                }
                self.workout.body_weight = Double(updatedText)!
            }
        
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text!.isEmpty {
            textField.text = "0.0"
        }
    }
    
}
