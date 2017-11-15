//
//  MarkingTableViewCell.swift
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

class MarkingTableViewCell: UITableViewCell {

    @IBOutlet weak var currentStage:UILabel?
    @IBOutlet weak var imagesCount:UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.imagesCount?.titleLabel?.textColor = UIColor.purple

        // Configure the view for the selected state
    }
        
    @IBAction func gotToImages(sender: UIButton){
        
        let nvc:UINavigationController? = (UIApplication.shared.keyWindow?.rootViewController)! as! UINavigationController
        let vc:UIViewController? = nvc?.topViewController
        
        vc?.performSegue(withIdentifier: "imageSegue", sender: nil)
    }

}
