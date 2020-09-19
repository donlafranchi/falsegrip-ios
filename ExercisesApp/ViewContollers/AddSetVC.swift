//
//  AddSetVC.swift
//  ExercisesApp
//
//  Created by developer on 9/10/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

protocol AddSetVCDelegate {
    func cancel()
    func done(_ added: Bool)
    func tapAdd()
    func tapAddMore()
}

class AddSetVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var sets: [SetsModel]?
    var addedSets = [SetsModel]()
    var workoutId: String?
    var exerciseId: String?
    var num = 0
    
    var delegate: AddSetVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        num = sets!.count + 1
        self.tableView.reloadData()
        if self.sets!.count > 0 {
            self.tableView.scrollToBottom()
        }
       
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    

    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.cancel()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        
        if self.addedSets.count == 0 {
            delegate?.done(false)
        }else{
            self.showHUD()
            for i in 0...self.addedSets.count - 1 {
                let params = [
                    "num": self.addedSets[i].num,
                    "reps": self.addedSets[i].reps,
                    "workout": self.addedSets[i].workout,
                    "exercise": self.addedSets[i].exercise] as [String : Any]
                ApiService.workoutSets(workoutId: self.workoutId!, params: params) { (success, data) in
                    
                    if success {
                        if i == self.addedSets.count - 1 {
                            self.delegate?.done(true)
                        }
                    }else{
                        self.dismissHUD()
                        self.delegate?.done(false)
                    }
                }
            }
        }
    }
    
    @IBAction func didTapAddMore(_ sender: Any) {
//        self.repes.append(0)
//        self.tableView.scrollToBottom()
        delegate?.tapAddMore()
    }
    
    @IBAction func didTapMinuse(_ sender: UIButton) {
        
//        if self.repes[sender.tag] < 1 {
//            return
//        }
        
//        self.repes[sender.tag] -= 1
    }
    
    @IBAction func didTapPlus(_ sender: UIButton) {
        
//         self.repes[sender.tag] += 1
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        
        let setModel = SetsModel()
        setModel.workout = self.workoutId!
        setModel.exercise = self.exerciseId!
        setModel.reps = pickerView.selectedRow(inComponent: 0) + 1
        setModel.num = num
        
        addedSets.append(setModel)
        self.sets?.append(setModel)
        num += 1
        self.tableView.reloadData()
        if self.sets!.count > 0 {
            self.tableView.scrollToBottom()
        }
        delegate?.tapAdd()
    }
}

extension AddSetVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSetTVCell", for: indexPath) as! AddSetTVCell
        cell.lblSet.text = "\(indexPath.row + 1) Set"
        print(indexPath.row)
        cell.lblReps.text = "\(sets![indexPath.row].reps)"
        
        if sets![indexPath.row].reps > 1 {
            cell.lblSub.text = "reps"
        }else{
            cell.lblSub.text = "rep"
        }
        
        if indexPath.row < sets![indexPath.row].reps - 1{
            cell.lblSet.font = UIFont(name: "Mulish-SemiBold", size: 16)
        }else{
            cell.lblSet.font = UIFont(name: "Mulish-Bold", size: 16)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension AddSetVC: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
}
