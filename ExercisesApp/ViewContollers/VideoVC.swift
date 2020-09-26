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
import YouTubePlayer

class VideoVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayerBackgroundView: UIView!
//    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    
    let firstNetworkURL = URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
    var videoPath: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

//        let firstAsset = AVURLAsset(url: URL(string: "https://youtu.be/x-WosgklhR0?t=189s")!)
//        videoPlayer.videoAssets = [firstAsset]
//
//
//        videoPlayer.resizeClosure = { [unowned self] isExpanded in
//
//            let videoVC = self.storyboard!.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
//            videoVC.url =  "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
//            videoVC.modalPresentationStyle = .fullScreen
//            self.present(videoVC, animated: true, completion: nil)
//        }
//        videoPlayer.layer.cornerRadius = 6
//        videoPlayer.layer.masksToBounds = true
//        videoPlayer.delegate = self
        
        print(videoPath)
        if self.videoPath != nil {
            videoPlayer.layer.cornerRadius = 6
            videoPlayer.layer.masksToBounds = true
            videoPlayer.loadVideoURL(videoPath!)
            videoPlayer.play()
        }
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
