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
    func deletedSet()
}

class AddSetVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSet: UILabel!
    @IBOutlet weak var setField: UITextField!
    @IBOutlet weak var setView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var sets: [SetsModel]? = []
    var addedSets = [SetsModel]()
    var workoutId: String?
    var exerciseId: String?
    var exerciseName: String?
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
        setField.becomeFirstResponder()
        self.setView.isHidden = false
        self.lblSet.text = ""
        self.setField.text = ""
        self.moreBtn.isHidden = true
        self.lblDesc.isHidden = false
        self.lblTitle.text = self.exerciseName
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
//        delegate?.tapAddMore()
        self.setField.becomeFirstResponder()
        self.setView.isHidden = false
        self.lblSet.text = ""
        self.setField.text = ""
        self.moreBtn.isHidden = true
        self.lblDesc.isHidden = false
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
        setModel.reps = Int(self.lblSet.text!)!
        setModel.num = num
        
        addedSets.append(setModel)
        self.sets?.append(setModel)
        num += 1
        self.tableView.reloadData()
        if self.sets!.count > 0 {
            self.tableView.scrollToBottom()
        }
        self.setView.isHidden = true
        self.lblSet.text = ""
        self.setField.text = ""
        self.setField.resignFirstResponder()
        self.moreBtn.isHidden = false
        self.lblDesc.isHidden = true
//        delegate?.tapAdd()
    }
}

extension AddSetVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSetTVCell", for: indexPath) as! AddSetTVCell
        cell.lblSet.text = "Set \(indexPath.row + 1)"
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
           
            showConfirmAlert("Warning", msg: "Do you want to delete Set?") { (ok) in
                if ok {
                    for (index,item) in self.addedSets.enumerated() {
                        if item == self.sets![indexPath.row] {
                            self.sets?.remove(at: indexPath.row)
                            self.addedSets.remove(at: index)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                            self.tableView.reloadData()
                            return
                        }
                    }
                    
                    self.showHUD()
                    ApiService.deleteSets(workoutId: self.workoutId!,id: self.sets![indexPath.row].id) { (deleted) in
                        self.dismissHUD()
                        if deleted {
                            self.sets?.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                            self.tableView.reloadData()
                            self.delegate?.deletedSet()
                            
                        }else{
                            self.showFailureAlert()
                        }
                    }
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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

extension AddSetVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = textField.text,
            let textRange = Range(range, in: str) {
            let updatedText = str.replacingCharacters(in: textRange,
                                                       with: string)
            
            if updatedText.count > 3 {
                return false
            }
            
            self.lblSet.text = updatedText
            self.addBtn.isEnabled = updatedText.count > 0
            
            
        
        }
        return true
    }
    
}
