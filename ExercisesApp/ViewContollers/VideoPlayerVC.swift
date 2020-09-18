//
//  VideoPlayerVC.swift
//  ExercisesApp
//
//  Created by developer on 9/19/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import MBVideoPlayer

class VideoPlayerVC: UIViewController {
    
    @IBOutlet weak var playerView: MBVideoPlayerView!

    var url = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let playerItems = [
                    PlayerItem(title: "", url: url, thumbnail: "")]
                
        if let currentItem = playerItems.first {
            playerView.setPlayList(currentItem: currentItem, items: playerItems, fullScreenView: view)
        }
        
        playerView.pinEdges(to: view)
        
        playerView.playerStateDidChange = { (state) in
            
        }
        playerView.playerOrientationDidChange = { (orientation) in
        
        }
        playerView.playerDidChangeSize = { (dimension) in
            
        }
        playerView.playerTimeDidChange = { (newTime, duration) in
            
        }
        playerView.playerDidSelectItem = { (index) in
            
        }
        playerView.didSelectOptions = { (index) in
            let controller = UIAlertController(title: "Options", message: "select below options", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Save video", style: .default) { (action) in
                
            }
            let action2 = UIAlertAction(title: "Mark as spam", style: .default) { (action) in
                
            }
            let action3 = UIAlertAction(title: "Delete video", style: .default) { (action) in
                
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            controller.addAction(action1)
            controller.addAction(action2)
            controller.addAction(action3)
            controller.addAction(cancel)
            self.present(controller, animated: true, completion: nil)
            
        }
        playerView.playPause(true)
    }
    

    @IBAction func didTapClose(_ sender: Any) {
        playerView.playPause(false)
        self.dismiss(animated: true, completion: nil)
    }
    

}
