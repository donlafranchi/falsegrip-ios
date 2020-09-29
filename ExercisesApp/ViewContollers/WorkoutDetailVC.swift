//
//  WorkoutDetailVC.swift
//  ExercisesApp
//
//  Created by developer on 9/10/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import FittedSheets
import EasyTipView
import CRRefresh
import CRNotifications


class WorkoutDetailVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var batteryImgView: UIImageView!    
    @IBOutlet weak var weightImgView: UIImageView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var noteImgView: UIImageView!
    @IBOutlet weak var weightView: UIStackView!
    
    var workoutID = ""
    var workout = WorkoutModel()
    var exercises = [Exercise]()
//    var exerciseDict = [String: [Exercise]]()
    var sections = [String]()
    
    var sheetController = SheetViewController()
    var addSetVC = AddSetVC()
    var preferences = EasyTipView.Preferences()
    var isFromCreate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTablveView()
        setupNotification()
        setUpBottomSlider()
        setTipView()
        getWorkout()
    }
    
    func reloadView(){
        
        self.tableView.reloadData()
        let category = sections.joined(separator: "/")
        self.lblCategory.text = self.workout.title
        self.reloadNoteView()

        
    }
    
    func reloadNoteView(){
        switch self.workout.energy_level {
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
        
        weightImgView.isHidden = self.workout.body_weight > 0
        weightView.isHidden = !(self.workout.body_weight > 0)
        lblWeight.text = "\(self.workout.body_weight)"
        noteImgView.image = self.workout.comments.isEmpty ? UIImage(named: "notes_empty") : UIImage(named: "notes")
    }
    
    func setupNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addToWorkoutNotification), name: Notification.Name("addToWorkoutNotification"), object: nil)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addToWorkoutNotification(notification: Notification) {
        
        if self.workout.isToday {
            if let id = notification.userInfo!["id"] as? String {
                self.workoutID = id
                self.getWorkout()
            }
        }else{
            self.getWorkout()
        }
        CRNotifications.showNotification(textColor: MAIN_COLOR!, backgroundColor: BACKGROUND_COLOR!, image: UIImage(named: "success"), title: "Success!", message: "You successfully add exercises to Workout.", dismissDelay: 2.0)
    }
    
    func setupTablveView(){
        
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        
        self.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getWorkout()
        }
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
        sheetController.view.gestureRecognizers?.removeAll()
        addSetVC.delegate = self
        sheetController.willDismiss = { _ in
            print("Will dismiss")
        }
        sheetController.didDismiss = { _ in
            
            print("Will dismiss")
        }
    }
    
    func getWorkout(){
        showHUD()
        ApiService.getWorkout(id: self.workoutID) { (success, data) in
            self.dismissHUD()
            if success {
                if let results = data {
                                        
                    self.workout = WorkoutModel(results)
                    self.exercises = self.workout.exercises
                    self.sections.removeAll()
                    for item in self.exercises {
                        
                        if !self.sections.contains(item.category) {
                            self.sections.append(item.category)
                        }
                    }
                    self.reloadView()
                    
                }
            }
            self.tableView.cr.endHeaderRefresh()
        }
    }
   
    @IBAction func didTapBack(_ sender: Any) {
        
        if isFromCreate {
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            back()
        }        
    }
    @IBAction func noteCancel(_ sender: Any) {
        noteBtn.backgroundColor = UNSELECT_COLOR

    }
    
    @IBAction func didTapNote(_ sender: Any) {
        
        if self.workout.isToday {
            return
        }
        
        noteBtn.backgroundColor = UNSELECT_COLOR
        let vc = storyboard?.instantiateViewController(withIdentifier: "StatusVC") as! StatusVC
        vc.delegate = self
        vc.workout = self.workout
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didDownNote(_ sender: Any) {
        noteBtn.backgroundColor = SELECT_COLOR
    }

    @IBAction func addExercise(_ sender: Any) {
        
        if self.workout.isToday {
            let vc = storyboard?.instantiateViewController(identifier: "AllExercisesVC") as! AllExercisesVC
            vc.isFromDetail = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "AddExercisesVC") as! AddExercisesVC
            vc.selectedExercises = self.exercises
            vc.workout = self.workout
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell" ) as! HeaderCell
//        headerView.lblMonth.text = sections[section]
//        return headerView
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesTVCell", for: indexPath) as! ExercisesTVCell
        cell.initCell(self.exercises[indexPath.row])
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ExercisesDetailVC") as! ExercisesDetailVC
        vc.exercise = self.exercises[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
//            showHUD()
//            ApiService.deleteWorkout(id: self.workoutDict[self.sections[indexPath.section]]![indexPath.row].id) { (deleted) in
//                self.dismissHUD()
//                if deleted {
//                    self.workoutDict[self.sections[indexPath.section]]!.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                }
//            }
            
            self.showConfirmAlert("Warning", msg: "Do you want to delete Exercise from Workout?") { (ok) in
                if ok {
                    self.showHUD()
                    var ids = [String]()
                    for item in self.exercises {
                        
                        if item.id == self.exercises[indexPath.row].id {
                            continue
                        }
                        ids.append(item.id)
                    }
                    let params = [
                        "exercises":ids] as [String : Any]
                    
                    ApiService.deleteExercise(id: self.workout.id,params: params) { (success) in
                        
                        if success {
                            self.getWorkout()
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("workoutUpdated"), object: nil)
                            
                        }else{
                            self.dismissHUD()
                        }
                    }
                    
                }
            }

        }
        

    }

}

extension WorkoutDetailVC: AddSetVCDelegate{
    func tapAdd() {
        self.sheetController.setSizes([.fixed(CGFloat(360))])
    }
    
    func tapAddMore() {
        self.sheetController.setSizes([.fixed(CGFloat(360 + 200))])
    }
    
    func done(_ updated: Bool) {
        self.sheetController.closeSheet()
        
        if updated {
            getWorkout()
        }
        
    }
    
    func cancel() {
        self.sheetController.closeSheet()
    }
    
    func deletedSet() {
        ApiService.getWorkout(id: self.workoutID) { (success, data) in
            if success {
                if let results = data {
                                        
                    self.workout = WorkoutModel(results)
                    self.exercises = self.workout.exercises
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension WorkoutDetailVC: StatusVCDelegate{
    
    func saveNote(_ workout: WorkoutModel) {
        self.workout = workout
        self.reloadNoteView()
        CRNotifications.showNotification(textColor: MAIN_COLOR!, backgroundColor: BACKGROUND_COLOR!, image: UIImage(named: "success"), title: "Success!", message: "You successfully updated Note.", dismissDelay: 2.0)
    }
}

extension WorkoutDetailVC: ExercisesTVCellDelegate{
    func tapAddSet(_ exercise: Exercise) {
        
        self.sheetController.setSizes([.fixed(CGFloat(360))])
        self.addSetVC.sets?.removeAll()
        self.addSetVC.sets = exercise.sets
        self.addSetVC.workoutId = self.workoutID
        self.addSetVC.exerciseId = exercise.id
        self.addSetVC.exerciseName = exercise.name
        self.addSetVC.addedSets.removeAll()
        self.present(sheetController, animated: false, completion: nil)
    }
    
}
