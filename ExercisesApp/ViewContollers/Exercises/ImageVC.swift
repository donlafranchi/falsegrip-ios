//
//  GifVC.swift
//  ExercisesApp
//
//  Created by developer on 9/19/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import SDWebImage

class ImageVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var imagePath:String?
    override func viewDidLoad() {
        super.viewDidLoad()

//        if !gifUrl!.isEmpty {
//            self.gifView?.setGifFromURL(URL(string: gifUrl!)!)
//        }
        
        let url = URL(string: "\(baseURL)\(self.imagePath!)")
        self.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        
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
