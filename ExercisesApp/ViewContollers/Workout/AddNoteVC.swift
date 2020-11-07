//
//  AddNoteVC.swift
//  ExercisesApp
//
//  Created by developer on 11/7/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import GrowingTextView

protocol AddNoteVCDelegate {
    func tapCancel()
    func tapDone(_ added: Bool)
}

class AddNoteVC: UIViewController {

    @IBOutlet weak var noteTextView: GrowingTextView!
    var delegate: AddNoteVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapDone(_ sender: Any) {
        delegate?.tapDone(true)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.tapCancel()
    }
    
}
