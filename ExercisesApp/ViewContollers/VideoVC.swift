//
//  VideoVC.swift
//  ExercisesApp
//
//  Created by developer on 9/19/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import ASPVideoPlayer
import AVFoundation

class VideoVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayerBackgroundView: UIView!
    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    
    let firstNetworkURL = URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
    override func viewDidLoad() {
        super.viewDidLoad()

        let firstAsset = AVURLAsset(url: firstNetworkURL!)
        videoPlayer.videoAssets = [firstAsset]
        
        
        videoPlayer.resizeClosure = { [unowned self] isExpanded in
            
            let videoVC = self.storyboard!.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
            videoVC.url =  "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
            videoVC.modalPresentationStyle = .fullScreen
            self.present(videoVC, animated: true, completion: nil)
        }
        videoPlayer.layer.cornerRadius = 6
        videoPlayer.layer.masksToBounds = true
        videoPlayer.delegate = self
    }

}

extension VideoVC: ASPVideoPlayerViewDelegate {
    func startedVideo() {
        print("Started video")
    }

    func stoppedVideo() {
        print("Stopped video")
    }

    func newVideo() {
        print("New Video")
    }

    func readyToPlayVideo() {
        print("Ready to play video")
    }

    func playingVideo(progress: Double) {
//        print("Playing: \(progress)")
    }

    func pausedVideo() {
        print("Paused Video")
    }

    func finishedVideo() {
        print("Finished Video")
    }

    func seekStarted() {
        print("Seek started")
    }

    func seekEnded() {
        print("Seek ended")
    }

    func error(error: Error) {
        print("Error: \(error)")
    }

    func willShowControls() {
        print("will show controls")
    }

    func didShowControls() {
        print("did show controls")
    }

    func willHideControls() {
        print("will hide controls")
    }

    func didHideControls() {
        print("did hide controls")
    }

}
