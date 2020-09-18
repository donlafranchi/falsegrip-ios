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
    

    let firstNetworkURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")

    var videoVC: VideoVC?
    var gifVC: GifVC?
    var pagingVC: PagingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let firstAsset = AVURLAsset(url: firstNetworkURL!)
//        videoPlayer.videoAssets = [firstAsset]
//        //        videoPlayer.configuration = ASPVideoPlayer.Configuration(videoGravity: .aspectFit, shouldLoop: true, startPlayingWhenReady: true, controlsInitiallyHidden: true, allowBackgroundPlay: true)
//
//        videoPlayer.resizeClosure = { [unowned self] isExpanded in
//            self.rotate(isExpanded: isExpanded)
//        }
//        videoPlayer.layer.cornerRadius = 6
//        videoPlayer.layer.masksToBounds = true
//        videoPlayer.delegate = self
        setupPageView()
        let nibName = UINib(nibName: "HeaderCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "HeaderCell")
    }

    override var prefersStatusBarHidden: Bool {
        return true
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
    
    
//    var previousConstraints: [NSLayoutConstraint] = []
//
//    func rotate(isExpanded: Bool) {
//        let views: [String:Any] = ["videoPlayer": videoPlayer as Any,
//                                   "backgroundView": videoPlayerBackgroundView as Any]
//
//        var constraints: [NSLayoutConstraint] = []
//
//        if isExpanded == false {
//            self.navigationController?.navigationBar.isHidden = true
//            self.containerView.removeConstraints(self.videoPlayer.constraints)
//
//            self.view.addSubview(self.videoPlayerBackgroundView)
//            self.view.addSubview(self.videoPlayer)
//            self.videoPlayer.frame = self.containerView.frame
//            self.videoPlayerBackgroundView.frame = self.containerView.frame
//
//            let padding = (self.view.bounds.height - self.view.bounds.width) / 2.0
//
//            var bottomPadding: CGFloat = 0
//
//            if #available(iOS 11.0, *) {
//                if self.view.safeAreaInsets != .zero {
//                    bottomPadding = self.view.safeAreaInsets.bottom
//                }
//            }
//
//            let metrics: [String:Any] = ["padding":padding,
//                                         "negativePaddingAdjusted":-(padding - bottomPadding),
//                                         "negativePadding":-padding]
//
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePaddingAdjusted)-[videoPlayer]-(negativePaddingAdjusted)-|",
//                                               options: [],
//                                               metrics: metrics,
//                                               views: views))
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[videoPlayer]-(padding)-|",
//                                               options: [],
//                                               metrics: metrics,
//                                               views: views))
//
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePadding)-[backgroundView]-(negativePadding)-|",
//                                               options: [],
//                                               metrics: metrics,
//                                               views: views))
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[backgroundView]-(padding)-|",
//                                               options: [],
//                                               metrics: metrics,
//                                               views: views))
//
//            self.view.addConstraints(constraints)
//        } else {
//            self.navigationController?.navigationBar.isHidden = false
//            self.view.removeConstraints(self.previousConstraints)
//
//            let targetVideoPlayerFrame = self.view.convert(self.videoPlayer.frame, to: self.containerView)
//            let targetVideoPlayerBackgroundViewFrame = self.view.convert(self.videoPlayerBackgroundView.frame, to: self.containerView)
//
//            self.containerView.addSubview(self.videoPlayerBackgroundView)
//            self.containerView.addSubview(self.videoPlayer)
//
//            self.videoPlayer.frame = targetVideoPlayerFrame
//            self.videoPlayerBackgroundView.frame = targetVideoPlayerBackgroundViewFrame
//
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "H:|[videoPlayer]|",
//                                               options: [],
//                                               metrics: nil,
//                                               views: views))
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "V:|[videoPlayer]|",
//                                               options: [],
//                                               metrics: nil,
//                                               views: views))
//
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|",
//                                               options: [],
//                                               metrics: nil,
//                                               views: views))
//            constraints.append(contentsOf:
//                NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|",
//                                               options: [],
//                                               metrics: nil,
//                                               views: views))
//
//            self.containerView.addConstraints(constraints)
//        }
//
//        self.previousConstraints = constraints
//
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//            self.videoPlayer.transform = isExpanded == true ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
//            self.videoPlayerBackgroundView.transform = isExpanded == true ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
//
//            self.view.layoutIfNeeded()
//        })
//    }
}

//extension ExercisesDetailVC: ASPVideoPlayerViewDelegate {
//    func startedVideo() {
//        print("Started video")
//    }
//
//    func stoppedVideo() {
//        print("Stopped video")
//    }
//
//    func newVideo() {
//        print("New Video")
//    }
//
//    func readyToPlayVideo() {
//        print("Ready to play video")
//    }
//
//    func playingVideo(progress: Double) {
////        print("Playing: \(progress)")
//    }
//
//    func pausedVideo() {
//        print("Paused Video")
//    }
//
//    func finishedVideo() {
//        print("Finished Video")
//    }
//
//    func seekStarted() {
//        print("Seek started")
//    }
//
//    func seekEnded() {
//        print("Seek ended")
//    }
//
//    func error(error: Error) {
//        print("Error: \(error)")
//    }
//
//    func willShowControls() {
//        print("will show controls")
//    }
//
//    func didShowControls() {
//        print("did show controls")
//    }
//
//    func willHideControls() {
//        print("will hide controls")
//    }
//
//    func didHideControls() {
//        print("did hide controls")
//    }
//}

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
