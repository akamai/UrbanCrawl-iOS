//
//  UCHomeTableViewController.swift
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
import VocSdk

class UCHomeTableViewController: UIViewController,UCServicesDelegate,UITableViewDataSource,UITableViewDelegate {
    var cityCount = 0
    var waitingView:UIView? = nil;
    var aniFlag = 0
    var devArray:Array = [Dictionary<String,String>]()
    var devText:String? = nil;
    var devTimer:Timer? = nil;
    var nextViewMetrics:Dictionary<String,String>? = nil
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var consoleView:UITextView!
    @IBOutlet weak var nQualityView:UIView!
    @IBOutlet weak var nQualityLabel:UILabel!
    @IBOutlet weak var devView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UrbanCrawl Logo
        let imageLogo = UIImage(named:"uclogo.png")
        let titleImageView = UIImageView(frame: CGRectFromString("{{0,0},{121,25}}"))
        titleImageView.image = imageLogo
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
        
        
        //RightBarButtons
        
        let item1:UIButton =  UIButton(type:.custom)
        item1.setImage(UIImage(named: "refresh.png"), for: .normal)
        item1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        item1.addTarget(self, action: #selector(self.refreshClicked), for: .touchUpInside)
        let bbitem1 = UIBarButtonItem(customView: item1)
        
        let item2:UIButton =  UIButton(type:.custom)
        item2.setImage(UIImage(named: "ic_bookmark"), for: .normal)
        item2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        item2.addTarget(self, action: #selector(self.planTravelClicked), for: .touchUpInside)
        let bbitem2 = UIBarButtonItem(customView: item2)
        
        let item3:UIButton = UIButton(type:.custom)
        item3.setImage(UIImage(named:"ic_settings.png"), for: .normal)
        item3.frame = CGRect(x:0, y:0, width:30, height:30)
        item3.addTarget(self, action: #selector(self.settingsClicked), for: .touchUpInside)
        let bbitem3 = UIBarButtonItem(customView: item3)
        
        let space:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 45;
        
        self.navigationItem.rightBarButtonItems = [bbitem1,bbitem2,bbitem3,space];

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        self.consoleView?.textColor = UIColor(red: 0.6157, green: 1, blue: 0, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        let services = UCServices.sharedInstance;
        services.delegate = self;
        
        if(services.cities.count == 0){
        services.requestPlacesAndImages()
        }
        
        services.selectedCity = nil
        self.nextViewMetrics = nil
        self.addressDevMode()
        self.updateDevConsole()

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
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UCServices.sharedInstance.cities.count //array count should be given here.
    }

   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell
        else{
            fatalError("The dequeued cell is not an instance of CityTableViewCell.")

        }
        
        let row = indexPath.row
        
        let city = UCServices.sharedInstance.cities[row]
        let cityName = city.value(forKey: "name") as! String?

        
        if(UCServices.sharedInstance.cityImages[cityName!] != nil) {
        cell.cityImageView!.image = UCServices.sharedInstance.cityImages[cityName!]
        }else{
        self.issueImageDownload(imageView:cell.cityImageView!, cell: cell, city: city)
        }
        
        cell.cityName!.text = cityName
        cell.countryName!.text = city.value(forKey: "countryname") as! String?
        
        // Configure the cell...

        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        self.waitingView = UCServices.sharedInstance.customActivityIndicatory(self.tableView.superview!, startAnimate: true)
        
        let city = UCServices.sharedInstance.cities[indexPath.row]
        let cityId = city.value(forKey:"id") as! Int?
        
        UCServices.sharedInstance.selectedCity = city
        
        UCServices.sharedInstance.requestPlacesForTheCity(cityId: cityId!)


    }
    func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
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
        if segue.identifier == "citySegue" {
            if let nextVC = segue.destination as? UCCityTableViewController {

                if(UCServices.sharedInstance.selectedCity == nil){
                NSLog("Singleton not instantiated with the selected item")
                }
                
                nextVC.devArray.append(nextViewMetrics!)
            }
        }

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
    
    func issueImageDownload(imageView:UIImageView,cell:CityTableViewCell, city:NSDictionary)
    {

        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x:0.0, y:0.0, width:30.0, height: 30.0)
        actInd.center = (imageView.superview?.center)!
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        imageView.superview?.addSubview(actInd)
        actInd.startAnimating()
        
        
        let url = city.value(forKey:"thumburl")
        let urlForTheRequest:URL? = URL(string:url as! String)
        var request:URLRequest = URLRequest(url:urlForTheRequest!)
        request.httpMethod = "GET"
        let StartDate = Date()
		var sessionConfiguration = URLSessionConfiguration.default
		VocServiceFactory.setupSessionConfiguration(sessionConfiguration)
		let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    
                    DispatchQueue.main.async{
                        
                        if(imageView.layer.sublayers != nil )
                        {
                            for  layer in imageView.layer.sublayers! {
                                layer.removeFromSuperlayer()
                            }
                        }
                        
                        let gradientLayer:CAGradientLayer = CAGradientLayer()
                        gradientLayer.frame.size = imageView.frame.size
                        gradientLayer.colors = [UIColor.purple.withAlphaComponent(0.5).cgColor,UIColor.white.withAlphaComponent(0.1).cgColor] //Use diffrent colors
                        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                        imageView.layer.addSublayer(gradientLayer)
                        
                        
                        let image:UIImage = UIImage(data:data)!
                        imageView.image = image
                        let cityName = city.value(forKey: "name") as! String?
                        UCServices.sharedInstance.cityImages[cityName!] = image
                        cell.setNeedsLayout()
                        actInd.removeFromSuperview()
                        
                        let executionTime = Date().timeIntervalSince(StartDate)
                        let metrics:[String:String] = ["URL":url as! String, "Time": String(executionTime)]
                        self.devArray.append(metrics)
                        self.updateDevConsole()

                    }
                    
                } else {

                    DispatchQueue.main.async{

                    actInd.removeFromSuperview()
                    cell.setNeedsLayout()
                    }
                }
            }
        })
        task.resume()

        
        
        
    }

 
    //MARK: UCServicesDelegate
    func getAllCitiesAPIResponse(placesDictionary:NSDictionary, responseCode:NSInteger, metrics:Dictionary<String, String>){
        
        print(placesDictionary)       
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.devArray.append(metrics)
        self.updateDevConsole()

    }
    
    func getAllPlacesAPIFailed(responseCode:NSString)
    {
        print("Error while retrieving cities API")
        
    }
    
    func imageReceivedForTheCity(data: NSData, tag: NSInteger) {
        
     
        let cityImage = UIImage(data:(data as NSData) as Data)
        let city:NSDictionary = UCServices.sharedInstance.cities[tag] as NSDictionary
        let cityName = city.value(forKey: "name") as! String?
        UCServices.sharedInstance.cityImages[cityName!] = cityImage;
        
        NSLog("Image Received for the City %@", cityName!);
        let indexPath:NSIndexPath = NSIndexPath(row:tag, section: 0)
        DispatchQueue.main.async {
        //self.tableView.reloadData()
        self.tableView.reloadRows(at:[indexPath as IndexPath], with: UITableViewRowAnimation.none)
        }
        
    }
    
    
    func imageFailedForTheCity(error: NSString) {
        
        print("image has failed while downloading")
    }

    
    @IBAction func planTravelClicked(sender: UIButton){
        
        self.navigationController!.performSegue(withIdentifier: "planTravelSegue", sender: nil)

    
    }
        
    @IBAction func settingsClicked(sender: UIButton){
        self.navigationController!.performSegue(withIdentifier: "settingsSegue", sender: nil)

        
    }
    
    @IBAction func refreshClicked(sender:UIButton){

        UCServices.sharedInstance.cities = []
        devArray = [Dictionary<String,String>]()
        UCServices.sharedInstance.cityImages = [String:UIImage]()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        UCServices.sharedInstance.requestPlacesAndImages()

        
   
        
    }
    
    func retrievedPlacesForCity(cityWithPlaces:NSDictionary, metrics:Dictionary<String,String>){
        
        self.nextViewMetrics  = metrics

        DispatchQueue.main.async {
        self.waitingView!.removeFromSuperview()
        self.performSegue(withIdentifier:"citySegue", sender:nil)

        }
        
        let cityName = cityWithPlaces.value(forKey: "name") as! String?

        print(cityWithPlaces)
        NSLog("Places retrieved for City: %@",cityName!);


        
    }
    
    func  failedToRetrievePlacesForCityId(cityWithEmptyPlaces:NSDictionary){
        
        DispatchQueue.main.async {
            self.waitingView!.removeFromSuperview()
            self.performSegue(withIdentifier:"citySegue", sender:nil)

        }
        
        let cityName = cityWithEmptyPlaces.value(forKey: "name") as! String?

        NSLog("No Places available for the city: %@",cityName!);


    }
    
    func addressDevMode(){
        
        if(UCServices.sharedInstance.developerMode == true)
        {
            
            if(UCServices.sharedInstance.developerMode == true && self.devView?.superview == nil){
            devView?.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y+self.view.frame.size.height-220, width: self.view.frame.size.width, height:220)
            devView?.alpha = 0.9
            
            self.view.addSubview(devView!)
            self.view.bringSubview(toFront: devView!)
            nQualityView.alpha = 1.0
            self.aniFlag = 0
            
            self.devTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.kickInTimer), userInfo: nil, repeats: true)
                
           self.testNetworkQuality(sender: nil)
                
               /* self.devTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false){
                    
                    timer in
                    
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
                */
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
        default:
            nQualityView.backgroundColor = UIColor.lightGray
            nQualityLabel.text = "Not Available"
            break
            
        }

        
        
    }
    

}
