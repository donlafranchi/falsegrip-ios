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
import CRNotifications

class WorkoutHistoryVC: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    var rowCount = 0
    var pageNum = 1
    var nextPage = ""
    var workouts = [WorkoutModel]()
    var workoutDict = [String: [WorkoutModel]]()
    var sections = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        setUpTableView()
        getWorkouts()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.workoutCreatedNotification), name: Notification.Name("WorkoutCreated"), object: nil)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
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
                self.historyTableView.cr.endHeaderRefresh()
                self.historyTableView.cr.endLoadingMore()
                self.historyTableView.cr.noticeNoMoreData()
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
            dateFormatter.dateFormat = "LLLL"
            let monthName = dateFormatter.string(from: date)
            print(monthName)
            
            if self.workoutDict.keys.contains(monthName) {
                self.workoutDict[monthName]?.append(item)
            }else{
                self.workoutDict[monthName] = [item]
                self.sections.append(monthName)
            }
        }
        
       
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let monthName = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var isTodayExsit = false
        for item in self.workoutDict[monthName]! {
            
            let date = dateFormatter.date(from: item.datetime)!            
            if  Calendar.current.isDateInToday(date) {
                isTodayExsit = true
                break
            }
        }
        
        if !isTodayExsit {
            let dateTime = dateFormatter.string(from: Date())
            
            let todayWorkout = WorkoutModel()
            todayWorkout.isToday = true
            todayWorkout.datetime = dateTime
            
            if sections.contains(monthName) {
                self.workoutDict[monthName]?.insert(todayWorkout, at: 0)
            }else{
                self.sections.insert(monthName, at: 0)
                self.workoutDict[monthName]? = [todayWorkout]
            }
        }
        
        self.historyTableView.reloadData()
        self.historyTableView.cr.endHeaderRefresh()
        self.historyTableView.cr.endLoadingMore()

        
    }
    
    @objc func workoutCreatedNotification(notification: Notification) {
        
        self.pageNum = 1
        self.getWorkouts()
        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message: "You successfully created Workout.", dismissDelay: 5)
        
    }
    
    @IBAction func didTapCreateWorkout(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AllExercisesVC") as! AllExercisesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WorkoutHistoryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell" ) as! HeaderCell
        headerView.lblMonth.text = self.sections[section]
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.workoutDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutDict[self.sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHistoryTVCell", for: indexPath) as! WorkoutHistoryTVCell
        
        let workout = self.workoutDict[self.sections[indexPath.section]]![indexPath.row]
        cell.initCell(workout)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "WorkoutDetailVC") as! WorkoutDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
