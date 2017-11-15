//
//  ViewController.swift
//  UrbanCrawl
//
//  Created by Gokul Sengottuvelu on 10/4/17.
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
import INSPhotoGallery

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var useCustomOverlay = false
    var imageURLs:NSArray! = nil
    var photos:[INSPhotoViewable]? = []
    
    
    var aniFlag = 0
    var devArray:Array = [Dictionary<String,String>]()
    var devText:String? = nil;
    var devTimer:Timer? = nil;
    
    
    @IBOutlet weak var consoleView:UITextView!
    @IBOutlet weak var nQualityView:UIView!
    @IBOutlet weak var devView:UIView?
    @IBOutlet weak var nQualityLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.title  = "Image Gallery"


        for i in 1..<imageURLs.count{
            
            let imageURL:String = imageURLs.object(at: i) as! String
            let photo:INSPhotoViewable = INSPhoto(imageURL: URL(string:imageURL), thumbnailImageURL: URL(string:imageURL))
            photos?.append(photo)
            
        }
        
        for photo in photos! {
            var i = 0
            if let photo = photo as? INSPhoto {
                #if swift(>=4.0)
                    photo.attributedTitle = NSAttributedString(string:self.imageURLS.object(at: i), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                #else
                    photo.attributedTitle = NSAttributedString(string:self.imageURLs.object(at: i) as! String, attributes: [NSForegroundColorAttributeName: UIColor.white])
                #endif
            }
            i += 1
        }
        self.consoleView?.textColor = UIColor(red: 0.6157, green: 1, blue: 0, alpha: 1.0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageReceived), name: NSNotification.Name(rawValue: "imageNotification"), object: nil)
        
        self.addressDevMode()
        self.updateDevConsole()
        
    }
    
    func imageReceived(notificationObject:Notification)
    {
        let metrics = notificationObject.object as! Dictionary<String,String>
        self.devArray.append(metrics)
        self.updateDevConsole()
        
    }
    
    func updateDevConsole(){
        
        
        if(self.devView?.superview != nil){
            
            var consoleText:String = ""
            var totalTime:Double = 0.0
            
            for metric in self.devArray
            {
                let responseTime = metric["Time"]! as String
                let endPointURL  = metric["URL"]
                let responseTimeInFloat:Float = Float(responseTime)!
                
                
                consoleText  +=  "Endpoint:" + endPointURL!
                consoleText +=  "\n" + "ResponseTime:" + responseTime + "\n"
                
                
                if(responseTimeInFloat <= 0.1){
                    consoleText += "Retrieved from device Cache" + "\n"
                }
                
                totalTime +=   Double(responseTime)!
            }
            
            consoleText += "Total Time Taken:" + String(totalTime)
            
            DispatchQueue.main.async {
                self.consoleView.text = consoleText
            }
            
        }
    }
    
    func addressDevMode(){
        
        if(UCServices.sharedInstance.developerMode == true)
        {
            
            if(UCServices.sharedInstance.developerMode == true && self.devView?.superview == nil){
                devView?.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y+self.view.frame.size.height-220, width: self.view.frame.size.width, height:220)
                devView?.alpha = 0.9
                
                self.view.addSubview(devView!)
                self.view.bringSubview(toFront: devView!)
                nQualityView.backgroundColor = UIColor.green
                nQualityView.alpha = 1.0
                self.aniFlag = 0
                
                self.devTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.kickInTimer), userInfo: nil, repeats: true)
                self.testNetworkQuality(sender: nil)
                self.devTimer?.fire()
            }
            
        }
            
        else{
            devView?.removeFromSuperview()
            self.devTimer?.invalidate()
            self.devTimer = nil
        }
        
    }
    
    
    func kickInTimer(){
        
        if(self.aniFlag == 0){
            self.nQualityView.alpha = self.nQualityView.alpha-0.1
            
            if(self.nQualityView.alpha <= 0.1)
            {
                self.aniFlag = 1
            }
        }
        else{
            self.nQualityView.alpha = self.nQualityView.alpha+0.1
            
            if(self.nQualityView.alpha == 1)
            {
                self.aniFlag = 0
            }
        }
        
        
    }
    
    @IBAction func testNetworkQuality(sender:Any?)
    {
        let networkQuality:Int = (UIApplication.shared.delegate as! AppDelegate).testQuality()
        
        switch networkQuality {
        case 1:
            nQualityView.backgroundColor = UIColor.red
            nQualityLabel.text = "Poor"
            break
        case 2:
            nQualityView.backgroundColor = UIColor.orange
            nQualityLabel.text = "Good"
            break
        case 3:
            nQualityView.backgroundColor = UIColor.green
            nQualityLabel.text = "Excellent"
            break
        case 4:
            nQualityView.backgroundColor = UIColor.lightGray
            nQualityLabel.text = "Determining.."
            
            break
        default: break
            
        }
        
        
        
    }


}





extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleCollectionViewCell", for: indexPath) as! ExampleCollectionViewCell
        cell.populateWithPhoto((photos?[(indexPath as NSIndexPath).row])!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.width/3.2)
        
        return  CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ExampleCollectionViewCell
        let currentPhoto = photos?[(indexPath as NSIndexPath).row]
        let galleryPreview = INSPhotosViewController(photos: photos!, initialPhoto: currentPhoto, referenceView: cell)
        if useCustomOverlay {
            galleryPreview.overlayView = CustomOverlayView(frame: CGRect.zero)
        }
        
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos?.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? ExampleCollectionViewCell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
    
    
    
}
