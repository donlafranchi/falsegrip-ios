//
//  WorkoutDetailVC.swift
//  ExercisesApp
//
//  Created by developer on 9/10/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import FittedSheets


class WorkoutDetailVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var noteBtn: UIButton!
    let titles = ["Push","Pull","Abs","Legs"]
    
    var sheetController = SheetViewController()
    var addSetVC = AddSetVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = titles.joined(separator: "     ")
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        setUpBottomSlider()
    }
    
    
    func setUpBottomSlider(){
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        addSetVC = storyboard.instantiateViewController(withIdentifier: "AddSetVC") as! AddSetVC

        sheetController = SheetViewController(controller: addSetVC, sizes: [.fixed(360)])
        sheetController.adjustForBottomSafeArea = false
        sheetController.blurBottomSafeArea = false
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.topCornersRadius = 20
        sheetController.overlayColor = UIColor.init(white: 1, alpha: 0.7)
        sheetController.handleSize = .zero
        sheetController.containerView.layer.shadowColor = UIColor.gray.cgColor
        sheetController.containerView.layer.shadowOffset = CGSize(width: 0, height: -1)
        sheetController.containerView.layer.shadowRadius = 8
        sheetController.containerView.layer.shadowOpacity = 0.4
        sheetController.dismissOnPan = true
        sheetController.dismissOnBackgroundTap = true
        addSetVC.delegate = self
        sheetController.willDismiss = { _ in
            print("Will dismiss")
        }
        sheetController.didDismiss = { _ in
            
            print("Will dismiss")
        }
    }
   
    @IBAction func didTapBack(_ sender: Any) {
        back()
    }
    @IBAction func noteCancel(_ sender: Any) {
        noteBtn.backgroundColor = UNSELECT_COLOR

    }
    
    @IBAction func didTapNote(_ sender: Any) {
        noteBtn.backgroundColor = UNSELECT_COLOR
    }
    @IBAction func didDownNote(_ sender: Any) {
        noteBtn.backgroundColor = SELECT_COLOR
    }

    @IBAction func didTapAddSet(_ sender: UIButton) {
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
}


extension WorkoutDetailVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell" ) as! HeaderCell
        headerView.lblMonth.text = titles[section]
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesTVCell", for: indexPath) as! ExercisesTVCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

}

extension WorkoutDetailVC: AddSetVCDelegate{
    
    func done(_ reps: [Int]) {
        self.sheetController.closeSheet()
    }
    
    func cancel() {
        self.sheetController.closeSheet()
    }
}
