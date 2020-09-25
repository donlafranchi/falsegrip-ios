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
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var notesTextView: GrowingTextView!
    @IBOutlet weak var unitDropDown: DropDown!
    var minusTimer: Timer?
    var plusTimer: Timer?
    var workout = WorkoutModel()
    var delegate : StatusVCDelegate?
    var units = ["kg","lb"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initDropDown()
        self.lblWeight.text = "\(self.workout.body_weight)"
        self.energySlider.index = UInt(self.workout.energy_level)
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
        unitDropDown.text = units[0]
       
        unitDropDown.didSelect { (unit, index, id) in
            
//            self.note.unit = index
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
        self.lblWeight.text = "\(self.workout.body_weight)"
    }
    
    @objc func plusPress() {
        self.workout.body_weight += 0.5
        self.lblWeight.text = "\(self.workout.body_weight)"
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
        self.lblWeight.text = "\(self.workout.body_weight)"
    }
    
    @IBAction func didTapPlus(_ sender: Any) {
        
        self.workout.body_weight += 0.5
        self.lblWeight.text = "\(self.workout.body_weight)"
        
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
        
        self.workout.comments = notesTextView.text
        self.showHUD()
        var ids = [String]()
        for item in self.workout.exercises {
           ids.append(item.id)
        }
        
        let params = [
            "datetime": self.workout.datetime,
            "title": self.workout.title,
            "body_weight": self.workout.body_weight,
            "energy_level": self.workout.energy_level,
            "comments": self.workout.comments,
            "exercises":ids] as [String : Any]
        
        ApiService.updateWorkout(id: self.workout.id,params: params) { (success, data) in
            self.dismissHUD()
            if success {
                self.delegate?.saveNote(self.workout)
                self.back()
            }
        }        
        
    }
    
}
