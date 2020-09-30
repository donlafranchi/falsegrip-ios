//
//  OnboardingVC4.swift
//  ExercisesApp
//
//  Created by developer on 10/1/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import SwiftyGif


protocol OnboardingVC4Delegate {
    func tapAddset()
}
class OnboardingVC4: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    var delegate: OnboardingVC4Delegate?
    var exercise: Exercise?
    override func viewDidLoad() {
        super.viewDidLoad()

        let gif = try? UIImage(gifName: "up_arrow.gif")
        self.gifView.setGifImage(gif!, loopCount: -1)
        self.gifView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
    }
    
    @IBAction func didTapAddSet(_ sender: Any) {
        UserInfo.shared.setUserInfo(.showOnboarding4, value: true)
        self.dismiss(animated: true, completion: nil)
        self.delegate?.tapAddset()
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

extension OnboardingVC4: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesTVCell", for: indexPath) as! ExercisesTVCell
        cell.initCell(self.exercise!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
    }
 
}
