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
    
    private var profile: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDatePicker()
        getProfile()
    }
    
    
    private func initView(){
        
        self.nameField.text = self.profile?.first_name
        self.ageField.text = self.profile?.birthday
        self.ageField.delegate = self
        self.nameField.delegate = self
        self.weightField.delegate = self
        self.cityField.delegate = self
        if !(self.profile?.birthday.isEmpty)! {
            self.lblAge.text = "\(self.calculateAge(dob: self.profile!.birthday))"
        }else{
            self.lblAge.text = ""
        }
       
        self.weightField.text = "\(self.profile!.weight)"
        self.cityField.text = "\(self.profile!.city)"
    }
    
    private func initDatePicker(){
        
        self.ageField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    
    private func getProfile(){
        showHUD()
        ApiService.getProfile { (success, data) in
            self.dismissHUD()
            if success {
                self.profile = ProfileModel(data!)
                self.initView()
            }
        }
    }
    
    private func updateProfile(){
        
        if profile!.first_name.isEmpty {
            let dict = [NSLocalizedDescriptionKey: "Should not be empty"] as [String : Any]
            let error = NSError.init(domain: "MFDemoErrorDomain", code: 100, userInfo: dict)
            self.nameField.setError(error, animated: true)
            return
        }
        
        showHUD()
        var params = [
            "first_name": profile!.first_name] as [String : Any]
        
        if !profile!.birthday.isEmpty {
            params["birthday"] = profile!.birthday
        }
        params["weight"] = profile!.weight
        if !profile!.city.isEmpty {
            params["city"] = profile!.city
        }

        ApiService.updateProfile(id: profile!.id, params: params) { (success, data) in
            self.dismissHUD()
            if success {
                self.back()
            }
        }
    }
    
    @objc func tapDone() {
        if let datePicker = self.ageField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            self.ageField.text = dateformatter.string(from: datePicker.date)
            self.profile!.birthday = dateformatter.string(from: datePicker.date)
            
            if !self.ageField.text!.isEmpty {
                self.lblAge.text = "\(self.calculateAge(dob: self.ageField.text!))"
            }           
            
        }
        self.ageField.resignFirstResponder() // 2-5
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.back()
    }
   
    @IBAction func didTapSave(_ sender: Any) {
        self.updateProfile()
    }
}

extension ProfileVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField ==  ageField {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let datePicker = ageField.inputView as! UIDatePicker
            
            if !self.profile!.birthday.isEmpty {
                datePicker.setDate(dateFormatter.date(from: self.profile!.birthday)!, animated: true)
            }
            
        }

        if textField == nameField {
            nameField.setError(nil, animated: true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = textField.text,
            let textRange = Range(range, in: str) {
            let updatedText = str.replacingCharacters(in: textRange,
                                                       with: string)
            
            if textField == nameField {
                self.profile?.first_name = updatedText
            }
           
            if textField == weightField {
                if updatedText.isEmpty {
                    self.profile?.weight = 0
                }else{
                    self.profile?.weight = Int(updatedText)!
                }
            }
            
            if textField == cityField {
                self.profile?.city = updatedText
            }
        }
        return true
    }
}
