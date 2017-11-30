//
//  VideoTableViewCell.swift
//  UrbanCrawl
//
//  Created by Gokul Sengottuvelu on 9/25/17.
//  Copyright © Akamai Technologies, Inc. All rights reserved.//

/*
 * Copyright 2017 Akamai Technologies, Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import AVFoundation
import AVKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var playButton:UIButton?
    @IBOutlet weak var heroImage:UIImageView?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func playButtonClicker(sender: UIButton){
        
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        let vc:UIViewController? = (UIApplication.shared.keyWindow?.rootViewController)! as UIViewController
        vc?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
     
    }
}