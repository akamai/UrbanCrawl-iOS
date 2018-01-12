//
//  UCPlaceTableViewController.swift
//  UrbanCrawl
//
//  Created by Gokul Sengottuvelu on 9/25/17.
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
import VocSdk

class UCPlaceTableViewController: UIViewController,UCServicesDelegate,UITableViewDataSource,UITableViewDelegate {

    var placeDetails:NSDictionary? = nil
    var imageURLs:NSArray? = nil
    var waitingView:UIView? = nil
    var nextViewMetrics:Dictionary<String,String>? = nil;

    var aniFlag = 0
    var devArray:Array = [Dictionary<String,String>]()
    var devText:String? = nil;
    var devTimer:Timer? = nil;
    
    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var consoleView:UITextView!
    @IBOutlet weak var nQualityView:UIView!
    @IBOutlet weak var devView:UIView?
    @IBOutlet weak var nQualityLabel:UILabel!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UrbanCrawl Logo
        let imageLogo = UIImage(named:"uclogo.png")
        let titleImageView = UIImageView(frame: CGRectFromString("{{0,0},{121,25}}"))
        titleImageView.image = imageLogo
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
        
        let space:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 100;
        
        self.tableView?.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        let selectedPlace:NSDictionary = UCServices.sharedInstance.selectedPlace!
        self.placeDetails = selectedPlace.value(forKey: "placeDetails") as? NSDictionary
        UCServices.sharedInstance.delegate = self

        self.consoleView?.textColor = UIColor(red: 0.6157, green: 1, blue: 0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.nextViewMetrics = nil
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addressDevMode()
        self.updateDevConsole()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        UCServices.sharedInstance.delegate = nil
        self.imageURLs = nil
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 8
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        switch(section) {
            
        case 0: return  0.0
        case 1: return  35.0
        case 2: return  5.0
        case 3: return  35.0
        case 4: return  35.0
        case 5: return  3.0
        case 6: return  3.0
        case 7: return  3.0
        case 8: return  3.0
        default :return 40.0
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch(indexPath.section) {
        case 0: return  100
        case 1: return  165
        case 2: return  30
        case 3: return  250
        case 4: return  50.0
        case 5: return  50.0
        case 6: return  50.0
        case 7: return  50.0
        case 8: return  50.0
        default :return 0
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
            
        case 0: return  1
        case 1: return  1
        case 2: return  1
        case 3: return  1
        case 4: return  1
        case 5: return  1
        case 6: return  1
        case 7: return  1
        case 8: return  1
        default :return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        
        let placeName:String = UCServices.sharedInstance.selectedPlace?.value(forKey: "name") as! String

        switch(section) {
        case 0:return nil
        case 1:
        return "Virtual tour to \(placeName)"
        case 3:
        return "About \(placeName)"
        case 4:
        return "Other Information"
        default :return nil
            
        }
        
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let section = indexPath.section
        let cellIdentifier:String
        var returnCell:UITableViewCell? = nil
        
        let city = UCServices.sharedInstance.selectedCity
        let cityName = city?.value(forKey: "name") as! String?
        let placeName = UCServices.sharedInstance.selectedPlace?.value(forKey: "name")
        

        switch(section)
        {
        case 0:
            cellIdentifier = "CityTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell
                else{
                    fatalError("The dequeued cell is not an instance of CityTableViewCell.")
                    
            }
            
            if(cell.cityImageView?.image == nil){
            self.issueImageDownload(imageView:cell.cityImageView!, cell: cell, info:UCServices.sharedInstance.selectedPlace!, type:"thumb")
            }
            
            cell.cityName!.text = placeName as! String?//city.value(forKey: "name") as! String?
            cell.countryName!.text = cityName
            
            
            if( cell.cityImageView!.layer.sublayers != nil )
            {
                for  layer in  cell.cityImageView!.layer.sublayers! {
                    
                    layer.removeFromSuperlayer()
                    
                }
            }
            
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size =  cell.cityImageView!.frame.size
            gradientLayer.colors = [UIColor.purple.withAlphaComponent(0.5).cgColor,UIColor.purple.withAlphaComponent(0.3).cgColor,UIColor.white.withAlphaComponent(0.3).cgColor] //Use diffrent colors
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            cell.cityImageView!.layer.addSublayer(gradientLayer)
            returnCell = cell
            
            
        case 1:
            cellIdentifier = "VideoTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VideoTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
        
            cell.playButton?.isHidden = true;
           // cell.heroImage?.image = UIImage(named:"heroLiberty.jpg")
            
            if(cell.heroImage?.image == nil){
            self.issueImageDownload(imageView:cell.heroImage!, cell: cell, info:self.placeDetails!, type:"hero")
            }
            
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size =  cell.heroImage!.frame.size
            gradientLayer.colors = [UIColor.purple.withAlphaComponent(0.5).cgColor,UIColor.purple.withAlphaComponent(0.3).cgColor,UIColor.white.withAlphaComponent(0.3).cgColor] //Use diffrent colors
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            cell.heroImage!.layer.addSublayer(gradientLayer)
        
            
            returnCell = cell
            
        case 2:
            cellIdentifier = "MarkingViewIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MarkingTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            cell.currentStage?.text = "\(cityName!) > \(placeName as! CVarArg)"
        
            let numImages:NSNumber = self.placeDetails?.value(forKey: "numimages") as! NSNumber
            let numImageString:String = "\(numImages.intValue) Images Available"
            cell.imagesCount?.setTitle(numImageString, for: .normal)
            cell.imagesCount?.titleLabel?.textColor = UIColor.purple.withAlphaComponent(0.8)
            cell.currentStage?.textColor = UIColor.darkGray
            
            returnCell = cell
            
            
        case 3:
            cellIdentifier = "TextViewIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TextViewTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            cell.textView?.text = self.placeDetails?.value(forKey: "description") as! String!
           
            returnCell = cell
            
            
        case 4:
            cellIdentifier = "LabelCellIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            
            cell.imgView?.image = UIImage(named:"ic_best_time.png")
            cell.titleLabel?.text = "Best time to Visit"
            cell.valueLabel?.text = self.placeDetails?.value(forKey: "timings") as! String!
            
            returnCell = cell
            
        case 5:
            cellIdentifier = "LabelCellIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            
            cell.imgView?.image = UIImage(named:"ic_currency.png")
            cell.titleLabel?.text = "Currency"
            cell.valueLabel?.text = "Dollars"
            
            returnCell = cell
        case 6:
            cellIdentifier = "LabelCellIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            
            cell.imgView?.image = UIImage(named:"ic_language.png")
            cell.titleLabel?.text = "Language"
            cell.valueLabel?.text = "English"
            
            returnCell = cell
        case 7:
            cellIdentifier = "LabelCellIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            
            cell.imgView?.image = UIImage(named:"ic_population.png")
            cell.titleLabel?.text = "Population"
            cell.valueLabel?.text = "1503920"
            
            returnCell = cell
        case 8:
            cellIdentifier = "LabelCellIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            
            cell.imgView?.image = UIImage(named:"ic_distance.png")
            cell.titleLabel?.text = "Distance From Current Location"
            cell.valueLabel?.text = "112102 miles"
            
            returnCell = cell
            
            
        default:
            return returnCell!
        }
        
        
        
        return returnCell!
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if segue.identifier == "imageSegue" {
            if let nextVC = segue.destination as? ViewController {
                
                nextVC.devArray.append(self.nextViewMetrics!)
                if(self.imageURLs != nil){
                    nextVC.imageURLs = self.imageURLs!
                }
            }
        }
        
    }
        
    
    

    func issueImageDownload(imageView:UIImageView,cell:UITableViewCell, info:NSDictionary, type:NSString)
    {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x:0.0, y:0.0, width:30.0, height: 30.0)
        actInd.center = (imageView.superview?.center)!
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        imageView.superview?.addSubview(actInd)
        actInd.startAnimating()
        
        var url:NSString = ""
        
        if(type.isEqual(to:"thumb")){
           url = info.value(forKey:"heroimage") as! NSString
        }else{
           url = info.value(forKey:"heroimage") as! NSString
        }
        
        let urlAllowed:String  = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let urlForTheRequest:URL? = URL(string:urlAllowed as String)
        var request:URLRequest = URLRequest(url:urlForTheRequest!)
        request.httpMethod = "GET"
        
        
        let startDate = Date()
        
        //UC: MAP the custom session configuration to VOC Factory
        let sessionConfiguration = URLSessionConfiguration.default
        VocServiceFactory.setupSessionConfiguration(sessionConfiguration)
        let session = URLSession(configuration: sessionConfiguration)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    
                    DispatchQueue.main.async{
                        let image:UIImage = UIImage(data:data)!
                        imageView.image = image
                        cell.setNeedsLayout()
                        actInd.removeFromSuperview()
                    }
                    
                } else {
                    
                    DispatchQueue.main.async{
                        
                        actInd.removeFromSuperview()
                        cell.setNeedsLayout()
                    }
                }
                
                let executionTime = Date().timeIntervalSince(startDate)
                let metrics:[String:String] = ["URL":urlAllowed, "Time": String(executionTime)]
                self.devArray.append(metrics)
                self.updateDevConsole()

            }
        })
        task.resume()
        
    }
    
    
    func retrievedImages(imageURLS: NSArray, placeId: Int, metrics:Dictionary<String,String>) {
    
    if(imageURLS.count != 0)
    {
        self.imageURLs = imageURLS
        self.nextViewMetrics = metrics
        
        DispatchQueue.main.async {
            self.waitingView?.removeFromSuperview()
            self.waitingView = nil
            self.performSegue(withIdentifier: "imageSegue", sender: nil)
            
        }
    }
    else{
        
    }
    
}
    func failedToRetrieveImagesForPlace(placeId: Int) {
        
        DispatchQueue.main.async {
        self.waitingView?.removeFromSuperview()
        self.waitingView?.removeFromSuperview()
        self.waitingView = nil
        }
    }

 @IBAction func gotToImages(sender: UIButton)
 {
    
    let placeId:Int = self.placeDetails?.value(forKey:"id") as! Int
    
    DispatchQueue.main.async {

    self.waitingView = UCServices.sharedInstance.customActivityIndicatory((self.tableView?.superview!)!, startAnimate: true)
    }
    UCServices.sharedInstance.requestImagesFor(place: placeId, city: 0)

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
                self.view.layoutSubviews()
                
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


