//
//  GifVC.swift
//  ExercisesApp
//
//  Created by developer on 9/19/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import SwiftyGif

class GifVC: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    var gifUrl = "https://portal.vpworkouts.com/Media/Image/E305_Male_Motion.gif?t=01%2F01%2F0001%2000%3A00%3A00"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gifView?.setGifFromURL(URL(string: gifUrl)!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
