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
import YoutubePlayerView

class VideoVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayerBackgroundView: UIView!
//    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    @IBOutlet weak var videoPlayer: YoutubePlayerView!
    var isPlaying = false
    
    let firstNetworkURL = URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
    var videoPath: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isPlaying {
            initVideo()
        }
    }
    
    func initVideo(){
        
        if self.videoPath != nil {
            videoPlayer.layer.cornerRadius = 0
            videoPlayer.layer.masksToBounds = true
            print(Float(Int((getQueryStringParameter(url: videoPath!.absoluteString, param: "t")?.dropLast())!) ?? 0))
            let playerVars: [String: Any] = [
                "controls": 1,
                "modestbranding": 1,
                "playsinline": 1,
                "origin": "https://youtube.com"
            ]
            videoPlayer.delegate = self
            videoPlayer.loadWithVideoId(getYoutubeId(youtubeUrl: videoPath!.absoluteString)!, with: playerVars)
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }

}

extension VideoVC: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.fetchPlayerState { [self] (state) in
            print("Fetch Player State: \(state)")
            playerView.play()
            isPlaying = true
            playerView.seek(to: Float(Int((getQueryStringParameter(url: videoPath!.absoluteString, param: "t")?.dropLast())!) ?? 0), allowSeekAhead: true)
        }
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }

}
