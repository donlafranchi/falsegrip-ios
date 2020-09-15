//
//  WorkoutDetailVC.swift
//  ExercisesApp
//
//  Created by developer on 9/10/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import FittedSheets
import TagListView
import EasyTipView

class WorkoutDetailVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var batteryImgView: UIImageView!    
    @IBOutlet weak var weightImgView: UIImageView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var noteImgView: UIImageView!
    @IBOutlet weak var weightView: UIStackView!
    
    
    let titles = ["Push","Pull","Abs","Legs"]
    
    var sheetController = SheetViewController()
    var addSetVC = AddSetVC()
    var preferences = EasyTipView.Preferences()
    var note = NoteModel(){
        didSet{
            switch note.energyLevel {
            case 0:
                batteryImgView.image = UIImage(named: "battery_empty")
            case 1:
                batteryImgView.image = UIImage(named: "battery1")
            case 2:
                batteryImgView.image = UIImage(named: "battery2")
            case 3:
                batteryImgView.image = UIImage(named: "battery3")
            case 4:
                batteryImgView.image = UIImage(named: "battery4")
            case 5:
                batteryImgView.image = UIImage(named: "battery5")
            default:
                break
            }
            
            weightImgView.isHidden = note.weight > 0
            weightView.isHidden = !(note.weight > 0)
            lblWeight.text = "\(note.weight)"
            noteImgView.image = note.comments.isEmpty ? UIImage(named: "notes_empty") : UIImage(named: "notes") 
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        setUpBottomSlider()
        initTagView()
        setTipView()
    }
    
    func initTagView(){
        
        tagView.textFont = UIFont(name: "Mulish-Medium", size: 16)!
        tagView.alignment = .center
        tagView.removeAllTags()
        tagView.addTags(titles)
    }
    
    func setTipView(){
        

        preferences.drawing.font = UIFont(name: "Mulish-Medium", size: 16)!
        preferences.drawing.foregroundColor = MAIN_COLOR!
        preferences.drawing.backgroundColor = BACKGROUND_COLOR!
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "StatusVC") as! StatusVC
        vc.delegate = self
        vc.note = self.note
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didDownNote(_ sender: Any) {
        noteBtn.backgroundColor = SELECT_COLOR
    }

    @IBAction func didTapAddSet(_ sender: UIButton) {
        
        self.sheetController.setSizes([.fixed(CGFloat(360 + 200))])
        self.present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func tapNote(_ sender: Any) {
        
//        if !self.note.comments.isEmpty {
//            
//            EasyTipView.globalPreferences = preferences
//            EasyTipView.show(forView: noteImgView, text: note.comments)
//        }else{
//            didTapNote(self)
//        }
        didTapNote(self)
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
    func tapAdd() {
        self.sheetController.setSizes([.fixed(CGFloat(360))])
    }
    
    func tapAddMore() {
        self.sheetController.setSizes([.fixed(CGFloat(360 + 200))])
    }
    
    func done(_ reps: [Int]) {
        self.sheetController.closeSheet()
    }
    
    func cancel() {
        self.sheetController.closeSheet()
    }
}

extension WorkoutDetailVC: StatusVCDelegate{
    
    func saveNote(_ note: NoteModel) {
        self.note = note
    }
}
