//
//  OnboardingVC3.swift
//  ExercisesApp
//
//  Created by developer on 9/30/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import SwiftyGif

protocol OnboardingVC3Delegate {
    func tapStart()
}

class OnboardingVC3: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    var delegate: OnboardingVC3Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let gif = try? UIImage(gifName: "up_arrow.gif")
        self.gifView.setGifImage(gif!, loopCount: -1)
        self.gifView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
    }

    @IBAction func didTapStartWorkout(_ sender: Any) {
        UserInfo.shared.setUserInfo(.showOnboarding3, value: true)
        self.dismiss(animated: true, completion: nil)
        self.delegate?.tapStart()
    }
    
}
