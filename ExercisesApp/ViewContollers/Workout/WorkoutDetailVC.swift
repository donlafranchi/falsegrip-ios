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
import SwiftReorder
import TableViewDragger

class WorkoutDetailVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var batteryImgView: UIImageView!    
    @IBOutlet weak var weightImgView: UIImageView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var noteImgView: UIImageView!
    @IBOutlet weak var weightView: UIStackView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var moreBtn: UIBarButtonItem!
    var dragger: TableViewDragger!
    var initIndexPath = IndexPath()
    var workoutID = ""
    var workout = WorkoutModel()
    var exercises = [Exercise]()
//    var exerciseDict = [String: [Exercise]]()
    var sections = [String]()
    
    var sheetController = SheetViewController()
    var noteSheetController = SheetViewController()

    var addSetVC = AddSetVC()
    var addNoteVC = AddNoteVC()
    var moreSheet = SheetViewController()
    var moreVC = WorkoutMoreVC()
    var preferences = EasyTipView.Preferences()
    var isFromCreate = false
    var isEdit = false {
        didSet{
            if isEdit {
                moreBtn.image = nil
                moreBtn.title = "Done"
            }else{
                moreBtn.image = UIImage(named: "ic_more")
                moreBtn.title = ""
            }
        }
    }
    
    var isSort = false {
        didSet{
            tableView.reloadData()
            if isSort {
                dragger = TableViewDragger(tableView: tableView)
                dragger.availableHorizontalScroll = false
                dragger.dataSource = self
                dragger.delegate = self
            }else{
                dragger = nil
            }
        }
    }
    
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
        self.titleField.text = self.workout.title
        self.reloadNoteView()

        
    }
    
    func reloadNoteView(){
//        switch self.workout.energy_level {
//        case 0:
//            batteryImgView.image = UIImage(named: "battery_empty")
//        case 1:
//            batteryImgView.image = UIImage(named: "battery1")
//        case 2:
//            batteryImgView.image = UIImage(named: "battery2")
//        case 3:
//            batteryImgView.image = UIImage(named: "battery3")
//        case 4:
//            batteryImgView.image = UIImage(named: "battery4")
//        case 5:
//            batteryImgView.image = UIImage(named: "battery5")
//        default:
//            break
//        }
//
//        weightImgView.isHidden = self.workout.body_weight > 0
//        weightView.isHidden = !(self.workout.body_weight > 0)
//        lblWeight.text = "\(self.workout.body_weight)"
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
//        self.tableView.reorder.delegate = self
//        self.tableView.reorder.isEnabled = false
        
        if isSort {
            dragger = TableViewDragger(tableView: tableView)
            dragger.availableHorizontalScroll = false
            dragger.dataSource = self
            dragger.delegate = self
        }else{
            dragger = nil
        }
        

        
    }
    
    func setTipView(){
        

        preferences.drawing.font = UIFont(name: "Mulish-Medium", size: 16)!
        preferences.drawing.foregroundColor = MAIN_COLOR!
        preferences.drawing.backgroundColor = BACKGROUND_COLOR!
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
    }
    
    func setUpBottomSlider(){
        
        // Add Set
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
        
        // More Sheet
        
        moreVC = storyboard.instantiateViewController(withIdentifier: "WorkoutMoreVC") as! WorkoutMoreVC

        moreSheet = SheetViewController(controller: moreVC, sizes: [.fixed(270)])
        moreSheet.adjustForBottomSafeArea = false
        moreSheet.blurBottomSafeArea = false
        moreSheet.dismissOnBackgroundTap = true
        moreSheet.extendBackgroundBehindHandle = false
        moreSheet.topCornersRadius = 20
        moreSheet.overlayColor = UIColor.init(white: 1, alpha: 0.7)
        moreSheet.handleSize = .zero
        moreSheet.containerView.layer.shadowColor = UIColor.gray.cgColor
        moreSheet.containerView.layer.shadowOffset = CGSize(width: 0, height: -1)
        moreSheet.containerView.layer.shadowRadius = 8
        moreSheet.containerView.layer.shadowOpacity = 0.4
        moreSheet.dismissOnPan = true
        moreSheet.dismissOnBackgroundTap = true
        moreVC.delegate = self
        
        // AddNote Sheet
        
        addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNoteVC") as! AddNoteVC

        noteSheetController = SheetViewController(controller: addNoteVC, sizes: [.fixed(270)])
        noteSheetController.adjustForBottomSafeArea = false
        noteSheetController.blurBottomSafeArea = false
        noteSheetController.dismissOnBackgroundTap = true
        noteSheetController.extendBackgroundBehindHandle = false
        noteSheetController.topCornersRadius = 20
        noteSheetController.overlayColor = UIColor.init(white: 1, alpha: 0.7)
        noteSheetController.handleSize = .zero
        noteSheetController.containerView.layer.shadowColor = UIColor.gray.cgColor
        noteSheetController.containerView.layer.shadowOffset = CGSize(width: 0, height: -1)
        noteSheetController.containerView.layer.shadowRadius = 8
        noteSheetController.containerView.layer.shadowOpacity = 0.4
        noteSheetController.dismissOnPan = true
        noteSheetController.dismissOnBackgroundTap = true
        addNoteVC.delegate = self
    }
    
    func getWorkout(){
        showHUD()
        ApiService.getWorkout(id: self.workoutID) { (success, data) in
            self.dismissHUD()
            if success {
                if let results = data {
                                        
                    self.workout = WorkoutModel(results)
                    
                    var orders = [String]()
                    if !self.workout.order.isEmpty {
                        orders =  self.workout.order.components(separatedBy: ",")
                        var exercises = [Exercise]()
                        for item in orders {
                            for exercise in self.workout.exercises {
                                if exercise.id == item {
                                    exercises.append(exercise)
                                    break
                                }
                            }
                        }
                        self.exercises = exercises
                        
                    }else{
                        self.exercises = self.workout.exercises
                    }
                    self.sections.removeAll()
                    
                    if !UserInfo.shared.showOnboarding4 && self.exercises.count > 0{
                        DispatchQueue.main.async {
                            self.showOnboarding()
                        }
                    }
                    
                    for item in self.exercises {
                        
                        if !self.sections.contains(item.category) {
                            self.sections.append(item.category)
                        }
                    }
                    self.reloadView()
                    
                }
            }else{
                self.showFailureAlert()
            }
            self.tableView.cr.endHeaderRefresh()
        }
    }
    
    func showOnboarding(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingVC4") as! OnboardingVC4
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.exercise = self.exercises.first!
        self.present(vc, animated: true, completion: nil)
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
    
    @IBAction func didTapMore(_ sender: Any) {
        
        
        if isEdit {
            showHUD()
            if isSort {
                var ids = [String]()

                for item in self.exercises {
                    ids.append(item.id)
                }

                let orders = ids.joined(separator: ",")

                let params = [
                    "order": orders] as [String : Any]

                ApiService.updateWorkout2(id: self.workout.id,params: params) { (success, data) in
                    if success {
                        self.isSort = false
                        self.isEdit = false
                    }else{
                        self.showFailureAlert()
                    }
                    self.dismissHUD()
                }
            }else{
                if self.workout.title == self.titleField.text || titleField.text!.isEmpty{
                    self.titleField.isEnabled = false
                    self.titleField.resignFirstResponder()
                    self.isEdit = false
                    self.dismissHUD()
                    return
                }
                
                let params = [
                    "title": self.titleField.text] as! [String : String]
                
                ApiService.updateWorkout2(id: self.workout.id,params: params) { (success, data) in
                    if success {
                        self.workout.title = self.titleField.text!
                        self.titleField.isEnabled = false
                        self.titleField.resignFirstResponder()
                        self.isEdit = false
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("workoutUpdated"), object: nil)
                    }else{
                        self.showFailureAlert()
                    }
                    self.dismissHUD()
                }
            }
            

        }else{
            moreVC.workoutTitle = self.workout.title
            self.present(moreSheet, animated: true, completion: nil)
        }
        

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
        
//        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
//            return spacer
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesTVCell", for: indexPath) as! ExercisesTVCell
        cell.initCell(self.exercises[indexPath.row])
        cell.delegate = self
        cell.sortView.isHidden = !self.isSort
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
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

                    let orders = ids.joined(separator: ",")
                    
                    let params = [
                        "exercises":ids,
                        "order": orders] as [String : Any]
                    
                    ApiService.deleteExercise(id: self.workout.id,params: params) { (success) in
                        
                        if success {
                            self.getWorkout()
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("workoutUpdated"), object: nil)
                            
                        }else{
                            self.dismissHUD()
                            self.showFailureAlert()
                        }
                    }
                    
                }
            }

        }
        

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isSort
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
            }else{
                self.showFailureAlert()
            }
        }
    }
}

extension WorkoutDetailVC: StatusVCDelegate{
    
    func saveNote(_ workout: WorkoutModel) {
        self.workout = workout
        self.reloadNoteView()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("workoutUpdated"), object: nil)
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
    
    func tapAddNote(_ exercise: Exercise) {
        self.present(noteSheetController, animated: true, completion: nil)
    }
    
    func tapExercise(_ exercise: Exercise) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ExercisesDetailVC") as! ExercisesDetailVC
        vc.exercise = exercise
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WorkoutDetailVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = textField.text,
            let textRange = Range(range, in: str) {
            let updatedText = str.replacingCharacters(in: textRange,
                                                       with: string)
           
//            editBtn.isSelected = !updatedText.elementsEqual(self.workout.title)
            
        
        }
        return true
    }
    
}

extension WorkoutDetailVC: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        

    }
    
    func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {

    }
}

extension WorkoutDetailVC: OnboardingVC4Delegate{
    
    func tapAddset(){
        
        self.sheetController.setSizes([.fixed(CGFloat(360))])
        self.addSetVC.sets?.removeAll()
        self.addSetVC.sets = self.exercises.first?.sets
        self.addSetVC.workoutId = self.workoutID
        self.addSetVC.exerciseId = self.exercises.first?.id
        self.addSetVC.exerciseName = self.exercises.first?.name
        self.addSetVC.addedSets.removeAll()
        self.present(sheetController, animated: false, completion: nil)
    }
}

extension WorkoutDetailVC: WorkoutMoreVCDelegate{
    func tapClose() {
        self.moreSheet.closeSheet()
    }
    
    func tapEdit() {
        isEdit = true
        self.moreSheet.closeSheet()
        
        self.titleField.isEnabled = true
        self.titleField.becomeFirstResponder()
        
    }
    
    func tapRemove() {
        self.moreSheet.closeSheet()
        self.showHUD()
        ApiService.deleteWorkout(id: self.workout.id) { (deleted) in
            
            if deleted {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("workoutUpdated"), object: nil)
                self.back()
            }else{
                self.dismissHUD()
                self.showFailureAlert()
            }
        }   

        

    }
    
    func tapSort() {
        self.moreSheet.closeSheet()
        self.isEdit = true
        self.isSort = true
    }
        
}

extension WorkoutDetailVC: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        
        if isSort {
            tableView.moveRow(at: indexPath, to: newIndexPath)
            self.exercises.swapAt(indexPath.row, newIndexPath.row)

            return true
        }
        return false

    }
    
    func dragger(_ dragger: TableViewDragger, willBeginDraggingAt indexPath: IndexPath) {
        self.initIndexPath = indexPath
    }
    
    func dragger(_ dragger: TableViewDragger, didEndDraggingAt indexPath: IndexPath) {
        
    }
}

extension WorkoutDetailVC: AddNoteVCDelegate {
    func tapCancel() {
        self.noteSheetController.closeSheet()
    }
    
    func tapDone(_ added: Bool) {
        self.noteSheetController.closeSheet()
    }
    
}
