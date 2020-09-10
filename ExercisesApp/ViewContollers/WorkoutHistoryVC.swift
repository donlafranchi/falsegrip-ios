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
    var rowCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()


        showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.rowCount = 8
            self.historyTableView.reloadData()
            self.dismissHUD()
        }
        setUpTableView()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setUpTableView(){
        
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.historyTableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        
        let animator = RamotionAnimator(ballColor: UIColor(red: 0.027, green: 0.408, blue: 0.624, alpha: 0.4), waveColor: .white)
        animator.backgroundColor = .clear
        historyTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            /// start refresh
            /// Do anything you want...
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                /// Stop refresh when your job finished, it will reset refresh footer if completion is true
                self?.historyTableView.cr.endHeaderRefresh()
            })
        }
        
//        historyTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
//            /// start refresh
//            /// Do anything you want...
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                /// Stop refresh when your job finished, it will reset refresh footer if completion is true
//                self?.historyTableView.cr.endLoadingMore()
//                self?.historyTableView.cr.noticeNoMoreData()
//                /// Reset no more data
//                self?.historyTableView.cr.resetNoMore()
//            })
//        }
        historyTableView.cr.beginHeaderRefresh()
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
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHistoryTVCell", for: indexPath) as! WorkoutHistoryTVCell
        cell.lblMain.isHidden = indexPath.row == 0 && indexPath.section == 0
        cell.lblSub.isHidden = indexPath.row == 0 && indexPath.section == 0

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "WorkoutDetailVC") as! WorkoutDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
