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
import iOSDropDown

protocol StatusVCDelegate {
    func saveNote(_ note: NoteModel)
}

class StatusVC: UIViewController {

    @IBOutlet weak var energySlider: StepSlider!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var notesTextView: GrowingTextView!
    @IBOutlet weak var unitDropDown: DropDown!
    var minusTimer: Timer?
    var plusTimer: Timer?
    var note = NoteModel()
    var delegate : StatusVCDelegate?
    var units = ["kg","lb"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initDropDown()
        lblWeight.text = "\(note.weight)"
        self.energySlider.index = UInt(note.energyLevel)
        notesTextView.text = note.comments
        
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
        unitDropDown.selectedIndex = note.unit
       
        unitDropDown.didSelect { (unit, index, id) in
            
            self.note.unit = index
        }
    }

    func startMinusTimer(){
         minusTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(minusPress), userInfo: nil, repeats: true)
    }
    
    func startPlusTimer(){
        plusTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(plusPress), userInfo: nil, repeats: true)
    }
    
    @objc func minusPress() {
        if note.weight == 0 {
            minusTimer?.invalidate()
            return
        }
        
        note.weight -= 0.5
        self.lblWeight.text = "\(note.weight)"
    }
    
    @objc func plusPress() {
        note.weight += 0.5
        self.lblWeight.text = "\(note.weight)"
    }

    @IBAction func didTapBack(_ sender: Any) {
         back()
    }
       
    @IBAction func didChangeEnergy(_ sender: StepSlider) {
        print(sender.index)
        note.energyLevel = Int(sender.index)
    }
    
    
    @IBAction func didTapMinuse(_ sender: Any) {
        
        if note.weight == 0 {
            return
        }
        
        note.weight -= 0.5
        self.lblWeight.text = "\(note.weight)"
    }
    
    @IBAction func didTapPlus(_ sender: Any) {
        
        note.weight += 0.5
        self.lblWeight.text = "\(note.weight)"
        
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
        self.back()
        note.comments = notesTextView.text
        delegate?.saveNote(note)
    }
    
}
