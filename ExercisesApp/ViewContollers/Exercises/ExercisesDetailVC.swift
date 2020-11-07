//
//  ExercisesDetailVC.swift
//  ExercisesApp
//
//  Created by developer on 9/8/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import Parchment
import YoutubePlayerView
//import ASPVideoPlayer
//import AVFoundation

class ExercisesDetailVC: UIViewController {

 
    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var videoPlayerBackgroundView: UIView!
//    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCreator: UILabel!
    @IBOutlet weak var lblPrimaryMusel: UILabel!
    @IBOutlet weak var lblSecondaryMusel: UILabel!
    @IBOutlet weak var videoPlayer: YoutubePlayerView!
    @IBOutlet weak var lblPersonalRecord: UILabel!
    @IBOutlet weak var lblTotalReps: UILabel!
    

    let firstNetworkURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")

    var videoVC: VideoVC?
    var imgVC: ImageVC?
    var pagingVC: PagingViewController?
    var exercise: Exercise?
    var exerciseHistory: Exercise?
    var historyDict = [String: [[String : Any]]]()
    var sections = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
//        initVideoView()
        setupPageView()
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        self.getExerciseHistory()
    }


    
    func initView(){
        
        self.title = self.exercise?.name
        self.lblCreator.text = self.exercise?.trainer_obj.name
        self.lblPrimaryMusel.text = self.exercise?.category
        self.lblSecondaryMusel.text = self.exercise?.muscle_category
    }
    
    func initVideoView(){
        
//        if let url = URL(string: self.exercise!.videoPath) {
//            videoPlayer.loadVideoURL(url)
//            videoPlayer.play()
//        }
    }

    func setupPageView(){
        
        videoVC = (storyboard?.instantiateViewController(withIdentifier: "VideoVC") as! VideoVC)
        videoVC!.videoPath = URL(string: self.exercise!.videoPath)
        imgVC = (storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC)
        imgVC!.imagePath = self.exercise!.imagePath
        pagingVC = PagingViewController(viewControllers: [imgVC!,videoVC!])
        pagingVC!.textColor = MAIN_COLOR!
        pagingVC!.selectedTextColor = COLOR2!
        pagingVC!.indicatorColor = COLOR2!
        pagingVC!.indicatorOptions = PagingIndicatorOptions.visible(height: 0, zIndex: 0, spacing:.zero, insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        pagingVC!.borderColor = UIColor.clear
        addChild(pagingVC!)
        containerView.addSubview(pagingVC!.view)
        pagingVC!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingVC!.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pagingVC!.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pagingVC!.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            pagingVC!.view.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        pagingVC!.didMove(toParent: self)
    }
     
    
    func getExerciseHistory(){
        showHUD()
        ApiService.getExerciseHistory(id: self.exercise!.id) { (success, data) in
            self.dismissHUD()
            if let results = data {
                self.exerciseHistory = Exercise(results)
                self.lblPersonalRecord.text = "\(self.exerciseHistory!.personal_record)"
                self.lblTotalReps.text = "\(self.exerciseHistory!.total_reps)"
                
                self.historyDict.removeAll()
                self.sections.removeAll()
                
                self.exerciseHistory!.history.forEach({ (key: String, value: Any) in
                    
                    let repsData = value as! [[String: Any]]
                    var repsResult = [[String: Any]]()

                    var reps = 0
                    for item in repsData {
                        reps += item.values.first as! Int
                        if item.values.first as! Int > 0 {
                            repsResult.append(item)
                        }
                    }
                    var repsDict = [String: [Int]]()
                    for item in repsResult {
                        
                        if repsDict.keys.contains(item.keys.first!) {
                            repsDict[item.keys.first!]?.append(item.values.first as! Int)
                        }else{
                            repsDict[item.keys.first!] = [item.values.first as! Int]
                        }
                    }
                    repsResult.removeAll()
                    repsDict.forEach { (key: String, value: [Int]) in
                        
                        var sum = 0
                        for item in value {
                            sum += item
                        }
                        repsResult.append([key : sum])
                    }
                    
                    if reps > 0 {
                        self.sections.append(key)
                        self.historyDict[key] = repsResult
                    }
                    
                })
                
                if self.sections.count > 1 {
                    for i in 0...self.sections.count - 2 {
                        
                        for j in i+1...self.sections.count - 1  {
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-M"
                            let date1 = dateFormatter.date(from:self.sections[j])!
                            let date2 = dateFormatter.date(from:self.sections[i])!
                            
                            if date1 >= date2 {
                                self.sections.swapAt(i, j)
                            }
                        }
                    }
                }
                
                self.tableView.reloadData()
            }else{
                self.showFailureAlert()
            }
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        back()
    }
    
    @IBAction func didTapYoutube(_ sender: Any) {
        
        if let url = URL(string: self.exercise!.trainer_obj.youtube_url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func didTapInsta(_ sender: Any) {
        if let url = URL(string: self.exercise!.trainer_obj.instagram_url) {
            UIApplication.shared.open(url)
        }
    }
}


extension ExercisesDetailVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell" ) as! HeaderCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M"
        let date = dateFormatter.date(from:self.sections[section])!
        
        dateFormatter.dateFormat = "yyyy LLL"
        let month = dateFormatter.string(from: date)
        
        headerView.lblMonth.text = month
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryContainerTVCell", for: indexPath) as! HistoryContainerTVCell
        cell.initCell(self.historyDict[sections[indexPath.section]]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        
        return CGFloat(32 * self.historyDict[sections[indexPath.section]]!.count + 68)
    }
}
