//
//  StatusVC.swift
//  ExercisesApp
//
//  Created by developer on 9/11/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import GrowingTextView

protocol StatusVCDelegate {
    func saveNote(_ note: NoteModel)
}

class StatusVC: UIViewController {

    @IBOutlet var energyViews: [UIView]!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var notesTextView: GrowingTextView!
    var minusTimer: Timer?
    var plusTimer: Timer?
    var isTap = false
    var note = NoteModel()
    var delegate : StatusVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        lblWeight.text = "\(note.weight)"
        changeEnergy(note.energyLevel)
        notesTextView.text = note.comments
        




    }
    
    func changeEnergy(_ selectedIndex: Int){
        
        for (index,item) in energyViews.enumerated() {
            
            if index <= selectedIndex - 1 {
                item.backgroundColor = COLOR3
            }else{
                item.backgroundColor = COLOR5
            }
        }
        
        note.energyLevel = selectedIndex
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
    
    @IBAction func tapEnergy1(_ sender: UITapGestureRecognizer) {
        
        if isTap {
           changeEnergy(0)
        }else{
           changeEnergy(1)
        }
        isTap = !isTap
    }
    
    @IBAction func tapEnergy2(_ sender: UITapGestureRecognizer) {
        changeEnergy(2)
        isTap = false
    }

    @IBAction func tapEnergy3(_ sender: UITapGestureRecognizer) {
        changeEnergy(3)
        isTap = false
    }
    
    @IBAction func tapEnergy4(_ sender: UITapGestureRecognizer) {
        changeEnergy(4)
        isTap = false
    }
    
    @IBAction func tapEnergy5(_ sender: UITapGestureRecognizer) {
        changeEnergy(5)
        isTap = false
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
