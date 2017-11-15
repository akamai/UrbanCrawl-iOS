//
//  CustomOverlayView.swift
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
import INSNibLoading

class CustomOverlayView: INSNibLoadedView {
    weak var photosViewController: INSPhotosViewController?
    
    // Pass the touches down to other views
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView != self {
            return hitView
        }
        return nil
    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        photosViewController?.dismiss(animated: true, completion: nil)
    }
}


extension CustomOverlayView: INSPhotosOverlayViewable {
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        
    }
    func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
                }, completion: { result in
                    self.alpha = 1.0
                    self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
}
