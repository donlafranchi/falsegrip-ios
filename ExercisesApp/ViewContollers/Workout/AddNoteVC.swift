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
    func tapDone(_ note: String)
}

class AddNoteVC: UIViewController {

    @IBOutlet weak var noteTextView: GrowingTextView!
    var note: String?
    var delegate: AddNoteVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.noteTextView.text = note
    }

    @IBAction func didTapDone(_ sender: Any) {
        
        if self.noteTextView.text == note || self.noteTextView.text.isEmpty {
            delegate?.tapCancel()
        }else{
            delegate?.tapDone(noteTextView.text)
        }        
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.tapCancel()
    }
    
}
