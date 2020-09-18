//
//  ExercisesDetailVC.swift
//  ExercisesApp
//
//  Created by developer on 9/8/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import Parchment
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
    

    let firstNetworkURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")

    var videoVC: VideoVC?
    var gifVC: GifVC?
    var pagingVC: PagingViewController?
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupPageView()
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func initView(){
        
        self.title = self.exercise?.name
        self.lblCreator.text = self.exercise?.creators
        self.lblPrimaryMusel.text = self.exercise?.primary_muscle
        self.lblSecondaryMusel.text = self.exercise?.secondary_muscle
    }

    func setupPageView(){
        
        videoVC = (storyboard?.instantiateViewController(withIdentifier: "VideoVC") as! VideoVC)
        gifVC = (storyboard?.instantiateViewController(withIdentifier: "GifVC") as! GifVC)
        pagingVC = PagingViewController(viewControllers: [videoVC!,gifVC!])
        
        pagingVC!.textColor = MAIN_COLOR!
        pagingVC!.selectedTextColor = COLOR2!
        pagingVC!.indicatorColor = COLOR2!
        pagingVC!.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: 0, spacing:.zero, insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        pagingVC!.borderColor = UIColor.clear
        // Make sure you add the PagingViewController as a child view
        // controller and contrain it to the edges of the view.
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
    
    @IBAction func didTapBack(_ sender: Any) {
        back()
    }
    
    @IBAction func didTapYoutube(_ sender: Any) {
        
        if let url = URL(string: "https://www.youtube.com/watch?v=aVk7duHInNE") {
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
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryContainerTVCell", for: indexPath) as! HistoryContainerTVCell
        cell.tableView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32 * 4 + 68
    }
}
