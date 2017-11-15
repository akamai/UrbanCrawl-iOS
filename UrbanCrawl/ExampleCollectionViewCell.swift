//
//  ExampleCollectionViewCell.swift
//  UrbanCrawl
//
//  Created by Gokul Sengottuvelu on 9/20/17.
//  Copyright © 2017 Akamai Technologies. All rights reserved.
//

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
import INSPhotoGallery

class ExampleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x:0.0, y:0.0, width:30.0, height: 30.0)
        actInd.center = (imageView.superview?.center)!
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        imageView.superview?.addSubview(actInd)
        actInd.startAnimating()
        
        
        let startDate = Date()
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in

            if let image = image {
                if let photo = photo as? INSPhoto {
                    DispatchQueue.main.async {
                        photo.thumbnailImage = image

                    }
                }
                
                if(photo == nil){
                return
                }
                let photoINS = photo as! INSPhoto

                let imageURL = photoINS.getImageURL()
                let executionTime = Date().timeIntervalSince(startDate)
                let metrics:[String:String] = ["URL":imageURL , "Time": String(executionTime)]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "imageNotification"), object:metrics)

                
                self.imageView.image = image
                actInd.stopAnimating()
                actInd.removeFromSuperview()
                
            }
        }
    }
}
