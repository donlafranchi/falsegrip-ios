//
//  SignupAlertVC.swift
//  ExercisesApp
//
//  Created by developer on 9/9/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import LGButton

protocol SignupAlertVCDelegate {
    func onSignup(_ name: String)
}

class SignupAlertVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!{
        didSet{
            nameField.layer.borderWidth = 2
            nameField.layer.borderColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 0.3).cgColor
            nameField.setLeftPaddingPoints(8)
        }
    }
    @IBOutlet weak var createBtn: LGButton!
    
    var delegate: SignupAlertVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func didTapCreate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.onSignup(nameField.text!)
    }
    

    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignupAlertVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = textField.text,
            let textRange = Range(range, in: str) {
            let updatedText = str.replacingCharacters(in: textRange,
                                                       with: string)
            createBtn.isUserInteractionEnabled = updatedText.count > 2
//
//            if updatedText.count > 2 {
//                createBtn.gradientEndColor = END_COLOR
//                createBtn.gradientStartColor = START_COLOR
//            }else{
//                createBtn.gradientEndColor = SUB_COLOR
//                createBtn.gradientStartColor = SUB_COLOR
//            }
        
        }
        return true
    }
}
