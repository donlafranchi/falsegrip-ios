//
//  OnboardingVC1.swift
//  ExercisesApp
//
//  Created by developer on 9/30/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import SwiftyGif

protocol OnboardingVC1Delegate {
    func tapCreate()
}

class OnboardingVC1: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var createBtn: UIButton!{
        didSet{
            createBtn.layer.borderWidth = 2
            createBtn.layer.borderColor = COLOR3?.cgColor
        }
    }
    
    var delegate: OnboardingVC1Delegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        let gif = try? UIImage(gifName: "up_arrow.gif")
        self.gifView.setGifImage(gif!, loopCount: -1)
    }
    
    @IBAction func didTapCreateWorkout(_ sender: Any) {
        
        UserInfo.shared.setUserInfo(.showOnboarding1, value: true)
        delegate?.tapCreate()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tapBackground(_ sender: Any) {
        UserInfo.shared.setUserInfo(.showOnboarding1, value: true)
        self.dismiss(animated: true, completion: nil)
    }
}
