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

class UCCityTableViewController: UIViewController,UCServicesDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var aniFlag = 0
    var devArray:Array = [Dictionary<String,String>]()
    var devText:String? = nil;
    var devTimer:Timer? = nil;
    var nextViewMetrics:Dictionary<String,String>? = nil



    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var consoleView:UITextView!
    @IBOutlet weak var nQualityView:UIView!
    @IBOutlet weak var devView:UIView?
    @IBOutlet weak var nQualityLabel:UILabel!

    
    
    var waitingView:UIView? = nil;
    


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
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)

        self.navigationItem.rightBarButtonItems = [space];

        self.consoleView?.textColor = UIColor(red: 0.6157, green: 1, blue: 0, alpha: 1.0)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let services = UCServices.sharedInstance;
        UCServices.sharedInstance.selectedPlace = nil

        services.delegate = self;
        self.addressDevMode()
        self.updateDevConsole()
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
 
    }

    override func viewDidAppear(_ animated: Bool) {
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 9
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
   
    switch(section) {
    
    case 0: return  0.0
    case 1: return  25
    case 2: return  25
    case 3: return  25
    case 4: return  25
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
        case 2: return  130
        case 3: return  150
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
        switch(section) {
        case 0:return nil
        case 1:return "Video"
        case 2:return "Places of Interest"
        case 3:return "About Tokyo"
        case 4:return "Other Information"
        default :return nil
            
        }

        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let section = indexPath.section
        let cellIdentifier:String
        var returnCell:UITableViewCell? = nil
        
        let city = UCServices.sharedInstance.selectedCity
        let cityName = city?.value(forKey: "name") as! String?
        let places = city?.value(forKey: "places") as! NSArray?
        
        switch(section)
        {
        case 0:
        cellIdentifier = "CityTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell
        else{
                fatalError("The dequeued cell is not an instance of CityTableViewCell.")
            
        }
        

        if(UCServices.sharedInstance.cityImages[cityName!] == nil) {}else {
            cell.cityImageView!.image = UCServices.sharedInstance.cityImages[cityName!]        }
        
        cell.cityName!.text = city?.value(forKey: "name") as! String?
        cell.countryName!.text = city?.value(forKey: "countryname") as! String?
        
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
        
        if(cell.heroImage!.layer.sublayers != nil )
        {
            for  layer in  cell.heroImage!.layer.sublayers! {
                
                layer.removeFromSuperlayer()
                
            }
        }
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size =  cell.heroImage!.frame.size
        gradientLayer.colors = [UIColor.purple.withAlphaComponent(0.5).cgColor,UIColor.purple.withAlphaComponent(0.3).cgColor,UIColor.white.withAlphaComponent(0.3).cgColor] //Use diffrent colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        cell.heroImage!.layer.addSublayer(gradientLayer)
        
        returnCell = cell
            
        case 2:
        cellIdentifier = "ScrollViewIdentifier"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScrollTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            cell.scrollView?.contentSize = CGSize(width: 600.0, height: 125)

        
        if(places != nil){
            self.addImages(view: cell.scrollView!, cell: cell, places:places!)}
    
            returnCell = cell
            
            
        case 3:
            cellIdentifier = "TextViewIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TextViewTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }
            cell.textView?.text = city?.value(forKey: "description") as! String?
            returnCell = cell
            
        
        case 4:
            cellIdentifier = "LabelCellIdentifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell else {
                
                fatalError("The dequeued cell is not an instance of VideoTableViewCell")
            }

            cell.imgView?.image = UIImage(named:"ic_best_time.png")
            cell.titleLabel?.text = "Best time to Visit"
            cell.valueLabel?.text = "9AM - 11PM"

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
            cell.titleLabel?.text = "Distance"
            cell.titleLabel?.sizeToFit()
            cell.valueLabel?.text = "112102 miles"
            
            returnCell = cell


        default:
            return returnCell!
        }
        
        
        
        return returnCell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "placeSegue" {
            if let nextVC = segue.destination as? UCPlaceTableViewController {
                
                if(UCServices.sharedInstance.selectedCity == nil){
                    NSLog("Singleton not instantiated with the selected item")
                }
                nextVC.devArray.append(self.nextViewMetrics!)
            }
        }

    }
    
    
    func addImages(view:UIScrollView,cell:ScrollTableViewCell, places:NSArray)
    {
        
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        var x:Float = 0
        let pad:Float = 10
        let hpad:Float = 5
        var y:Float = 0
        var width:Float = 0
        var height:Float = 0
        let scrollViewWidth:Float = Float(view.frame.size.width)
        let scrollViewHeight:Float = Float(view.frame.size.height)
        x = x+pad
        y = y+hpad
        width = ((scrollViewWidth) - (6*pad))/3
        height = ((scrollViewHeight) - (2*hpad))
        
        for i in 0..<places.count
        {
            let place = places[i] as! NSDictionary
      
            let rect:CGRect = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
            
            let containerView:UIView = UIView.init(frame:rect)
            containerView.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
            containerView.alpha = 1.0
            
            let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            actInd.frame = CGRect(x:0.0, y:0.0, width:30.0, height: 30.0)
            let centrex = width*0.46
            let centrey = height*0.45
            actInd.center = CGPoint(x:CGFloat(centrex), y:CGFloat(centrey))
            actInd.hidesWhenStopped = true
            actInd.activityIndicatorViewStyle =
                UIActivityIndicatorViewStyle.whiteLarge
            containerView.addSubview(actInd)
            actInd.startAnimating()
            
            
            let imageView:UIImageView = UIImageView.init(frame: containerView.bounds)
            imageView.backgroundColor = UIColor.clear
            //imageView.image = UIImage(named: "liberty.jpg")
            containerView.addSubview(imageView)
            
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size =  imageView.frame.size
            gradientLayer.colors = [UIColor.purple.withAlphaComponent(0.7).cgColor,UIColor.white.withAlphaComponent(0.1).cgColor] //Use diffrent colors
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            imageView.layer.addSublayer(gradientLayer)
            
            
            let imageURL:String = (place.value(forKey:"heroimage") as! String?)!
            let urlAllowed:String = imageURL.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
            let urlForTheRequest:URL? = URL(string:urlAllowed as String)
            var request:URLRequest = URLRequest(url:urlForTheRequest!)
            request.httpMethod = "GET"
            
            let StartDate = Date()
            let session = URLSession(configuration: URLSessionConfiguration.default)
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
                        }
                        print("Error downloading image for a place")
                    }
                    
                    let executionTime = Date().timeIntervalSince(StartDate)
                    let metrics:[String:String] = ["URL":urlAllowed, "Time": String(executionTime)]
                    self.devArray.append(metrics)
                    self.updateDevConsole()

                }
            })
            task.resume()
            
            let button:UIButton = UIButton(frame:containerView.bounds)
            button.backgroundColor = UIColor.clear
            button.setTitle("", for: .normal)
            button.addTarget(self, action: #selector(self.placeSelected), for: .touchUpInside)
            button.tag = i
            containerView.addSubview(button)
            
            
            let labelwidth = width - 2*pad
            
            let placeLabel = UILabel(frame: CGRect(x:5, y: 5, width: CGFloat(labelwidth), height: 18))
            placeLabel.textAlignment = .left
            placeLabel.font = UIFont.boldSystemFont(ofSize: 11)
            placeLabel.textColor = UIColor.white
            placeLabel.text = place.value(forKey: "name") as! String?
            placeLabel.numberOfLines = 1
            placeLabel.sizeToFit()
            containerView.addSubview(placeLabel)
            
            let cityLabel = UILabel(frame: CGRect(x:5, y: 20, width: CGFloat(width), height: 20))
            cityLabel.textAlignment = .left
            cityLabel.font = UIFont.systemFont(ofSize: 10)
            cityLabel.textColor = UIColor.white
            cityLabel.text = UCServices.sharedInstance.selectedCity?.value(forKey: "name") as! String?
            cityLabel.numberOfLines = 1
            cityLabel.sizeToFit()
            containerView.addSubview(cityLabel)
            
            view.addSubview(containerView)
        
            x = x+width+pad
            
            
        }
        
        let contentwidth:Float = (pad*2) * Float(places.count) + width*Float(places.count)
        
        view.contentSize = CGSize(width: CGFloat(contentwidth), height: view.frame.size.height)
    
    }
    
    @IBAction func placeSelected(_sender: AnyObject){
        
       let button:UIButton = _sender as! UIButton
       let placeIndex:Int = button.tag
       print("User cliced the place with Index:",placeIndex)
        
        let selectedCity:NSDictionary = UCServices.sharedInstance.selectedCity!
        let places:NSArray = selectedCity.value(forKey: "places") as! NSArray
        let selectedPlace:NSDictionary = places[placeIndex] as! NSDictionary
        UCServices.sharedInstance.selectedPlace = selectedPlace
        
        let placeId:Int = selectedPlace.value(forKey:"id") as! Int
        
        let placeDetails = selectedPlace.value(forKey: "placeDetails")
        
        if(placeDetails == nil){
        self.waitingView = UCServices.sharedInstance.customActivityIndicatory((self.tableView?.superview!)!, startAnimate: true)

        UCServices.sharedInstance.requestPlaceDetails(placeId: placeId)

        }
        else{
        self.performSegue(withIdentifier: "placeSegue", sender: nil)

        }
    }
    
    
    func retrievedPlaceDetailsForThePlace(placeId:Int, metrics:Dictionary<String,String>) {
        
        self.nextViewMetrics = metrics
        
        DispatchQueue.main.async{
            self.performSegue(withIdentifier: "placeSegue", sender: nil)
            self.waitingView?.removeFromSuperview()

        }
        
    }

    
    func failedToRetrievePlaceDetailsForThePlace(placeId: Int) {
        self.waitingView?.removeFromSuperview()

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

