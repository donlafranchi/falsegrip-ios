//
//  WorkoutHistoryVC.swift
//  ExercisesApp
//
//  Created by developer on 9/5/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import CRRefresh

class WorkoutHistoryVC: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var createBtn: UIButton!{
        didSet{
            createBtn.layer.borderWidth = 2
            createBtn.layer.borderColor = COLOR3?.cgColor
        }
    }

    
    var rowCount = 0
    var pageNum = 1
    var nextPage = ""
    var workouts = [WorkoutModel]()
    var workoutDict: [String: [WorkoutModel]] = [:]
    var sections = [String]()
    var isTodayExsit = false{
        didSet{
            if !isTodayExsit {
                createBtn.layer.borderColor = COLOR3?.cgColor
                createBtn.setTitleColor(COLOR3, for: .normal)
            }else{
                createBtn.layer.borderColor = SUB_COLOR?.cgColor
                createBtn.setTitleColor(SUB_COLOR, for: .normal)
            }
            createBtn.isEnabled = !isTodayExsit
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        setUpTableView()
        getWorkouts()
        
        if !UserInfo.shared.showOnboarding1 {
            showOnboarding()
        }
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.workoutCreatedNotification), name: Notification.Name("WorkoutCreated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.workoutUpdated), name: Notification.Name("workoutUpdated"), object: nil)

    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
    func showOnboarding(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingVC1") as! OnboardingVC1
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func setUpTableView(){
        
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.historyTableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        
        let animator = RamotionAnimator(ballColor: UIColor(red: 0.027, green: 0.408, blue: 0.624, alpha: 0.4), waveColor: .white)
        animator.backgroundColor = .clear
        historyTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.pageNum = 1
            self?.getWorkouts()
        }

        
        historyTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            
            if (self?.workouts.count)! < self!.rowCount {
                self?.getWorkouts()
            }else{
                self!.historyTableView.cr.noticeNoMoreData()
            }
             
        }
    }
    
    func getWorkouts(){
        self.showHUD()
        let params = [
            "order_by": ""] as [String : Any]
        ApiService.getWorkouts(page: pageNum, params: params) { (success, data) in
            self.dismissHUD()
            if success {
                if self.pageNum == 1 {
                    self.workouts.removeAll()
                }
                
                if let next = data!["next"] as? String, !next.isEmpty {
                    self.pageNum += 1
                }
                
                if let count = data!["count"] as? Int {
                    self.rowCount = count
                }
                
                if let results = data!["results"] as? [[String:Any]] {
                   
                    if results.count == 0 {
                        self.historyTableView.cr.noticeNoMoreData()
                    }else{
                        self.historyTableView.cr.resetNoMore()
                    }
                    
                    for item in results {
                        self.workouts.append(WorkoutModel(item))
                    }
                    self.sortWorkouts()
                }else{
                    self.historyTableView.cr.endHeaderRefresh()
                    self.historyTableView.cr.endLoadingMore()
                    self.historyTableView.cr.noticeNoMoreData()
                }
            }else{
                self.pageNum = 1
                self.workouts.removeAll()
                self.historyTableView.cr.endHeaderRefresh()
                self.historyTableView.cr.endLoadingMore()
                self.historyTableView.cr.noticeNoMoreData()
                
                self.showFailureAlert()
            }
        }
    }
    
    func sortWorkouts(){
        

        self.workoutDict.removeAll()
        self.sections.removeAll()
        
        for item in self.workouts {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from:item.datetime)!
            dateFormatter.dateFormat = "yyyy LLLL"
            let monthName = dateFormatter.string(from: date)
            print(monthName)
            
            if self.workoutDict.keys.contains(monthName) {
                self.workoutDict[monthName]!.append(item)
            }else{
                self.workoutDict[monthName] = [item]
                self.sections.append(monthName)
            }
        }
        
        checkIsTodayCreadted()
        
//        let dateTime = dateFormatter.string(from: Date())
//
//        let todayWorkout = WorkoutModel()
//        todayWorkout.isToday = true
//        todayWorkout.isCreated = isTodayExsit
//        todayWorkout.datetime = dateTime
//
//        if sections.contains(monthName) {
//            self.workoutDict[monthName]!.insert(todayWorkout, at: 0)
//        }else{
//            self.workoutDict[monthName] = [todayWorkout]
//            self.sections.insert(monthName, at: 0)
//
//        }
        
        self.historyTableView.reloadData()
        self.historyTableView.cr.endHeaderRefresh()
        self.historyTableView.cr.endLoadingMore()

        
    }
    
    func checkIsTodayCreadted(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy LLLL"
        let monthName = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        isTodayExsit = false
        
        if self.sections.contains(monthName) {
            for item in self.workoutDict[monthName]! {
                
                let date = dateFormatter.date(from: item.datetime)!
                if  Calendar.current.isDateInToday(date) {
                    isTodayExsit = true
                    break
                }
            }
        }
    }
    
    @objc func workoutCreatedNotification(notification: Notification) {
        
        self.pageNum = 1
        self.getWorkouts()

    }
    
    @objc func workoutUpdated(notification: Notification) {
        
        self.pageNum = 1
        self.getWorkouts()
    }
    
    @IBAction func didTapCreateWorkout(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AllExercisesVC") as! AllExercisesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    @IBAction func didTapViewExercises(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ExercisesViewVC") as! ExercisesViewVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "goSettings", sender: nil)
    }
    
}

extension WorkoutHistoryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell" ) as! HeaderCell
        headerView.lblMonth.text = String(self.sections[section].split(separator: " ")[1])
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.workoutDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutDict[self.sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if self.workoutDict[self.sections[indexPath.section]]![indexPath.row].isToday {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateWorkoutCell") as! CreateWorkoutCell
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHistoryTVCell", for: indexPath) as! WorkoutHistoryTVCell
        
        let workout = self.workoutDict[self.sections[indexPath.section]]![indexPath.row]
        cell.initCell(workout)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.workoutDict[self.sections[indexPath.section]]![indexPath.row].isToday {
            let vc = storyboard?.instantiateViewController(identifier: "WorkoutDetailVC") as! WorkoutDetailVC
            vc.workout = self.workoutDict[self.sections[indexPath.section]]![indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "WorkoutDetailVC") as! WorkoutDetailVC
            vc.workoutID = self.workoutDict[self.sections[indexPath.section]]![indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if self.workoutDict[self.sections[indexPath.section]]![indexPath.row].isToday {
            return
        }
        
        if editingStyle == .delete {
            
            self.showConfirmAlert("Warning", msg: "Do you want to delete Workout?") { (ok) in
                if ok {
                    self.showHUD()
                    ApiService.deleteWorkout(id: self.workoutDict[self.sections[indexPath.section]]![indexPath.row].id) { (deleted) in
                        self.dismissHUD()
                        if deleted {
                            self.workoutDict[self.sections[indexPath.section]]!.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            self.checkIsTodayCreadted()
                            self.pageNum = 1
                            self.getWorkouts()
                        }else{
                            self.showFailureAlert()
                        }
                    }
                    
                }
            }            

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}

extension WorkoutHistoryVC: OnboardingVC1Delegate {
    func tapCreate() {
        self.didTapCreateWorkout(self)
    }
}
