//
//  BaseNavVC.swift
//  ExercisesApp
//
//  Created by developer on 9/5/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import SwipeTransition

class BaseNavVC: SwipeBackNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.shadowImage = UIImage()
        let attrs = [NSAttributedString.Key.foregroundColor: MAIN_COLOR,
            NSAttributedString.Key.font: UIFont(name: "Mulish-Bold", size: 18)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs as [NSAttributedString.Key : Any]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

}
