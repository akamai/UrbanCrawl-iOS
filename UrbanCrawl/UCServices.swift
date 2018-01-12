//
//  UCServices.swift
//  UrbanCrawl
//
//  Created by Gokul Sengottuvelu on 9/21/17.
//  Copyright © Akamai Technologies, Inc. All rights reserved.
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

import Foundation
import UIKit
import CocoaLumberjack
import VocSdk

@objc protocol UCServicesDelegate:class{
    
    @objc optional   func getAllCitiesAPIResponse(placesDictionary:NSDictionary, responseCode:NSInteger, metrics:Dictionary<String, String>)
    @objc optional   func getAllPlacesAPIFailed(responseCode:NSString)
    @objc optional   func imageReceivedForTheCity(data:NSData, tag:NSInteger)
    @objc optional   func imageFailedForTheCity(error:NSString)
    @objc optional   func retrievedPlacesForCity(cityWithPlaces:NSDictionary, metrics:Dictionary<String,String>)
    @objc optional   func failedToRetrievePlacesForCityId(cityWithEmptyPlaces:NSDictionary)
    @objc optional   func retrievedPlaceDetailsForThePlace(placeId:Int, metrics:Dictionary<String,String>)
    @objc optional   func failedToRetrievePlaceDetailsForThePlace(placeId:Int)
    @objc optional   func retrievedImages(imageURLS:NSArray, placeId:Int, metrics:Dictionary<String,String>)
    @objc optional   func failedToRetrieveImagesForPlace(placeId:Int)
    
}

//UC: UCServices provides API services through the delegate UCServicesDelegate.

class UCServices
{
    
    weak var delegate:UCServicesDelegate?
    static let sharedInstance = UCServices()
    
    var cities:[NSDictionary] = []
    var cityImages = [String:UIImage]()
    
    var placeDictionary:NSDictionary = [:]
    var selectedCity:NSDictionary? = nil
    var selectedPlace:NSDictionary? = nil;
    var developerMode:Bool = false;
    
    private init(){}
    
    // MARK: - Network Services
    
    func requestPlacesAndImages()
    {
        
        let getAllCitiesURL = "https://terraplanet.herokuapp.com/api/cities/getAllCities"
        let urlForTheRequest:URL? = URL(string:getAllCitiesURL)
        var request:URLRequest = URLRequest(url:urlForTheRequest!)
        request.httpMethod = "GET"
        
        let startDate = Date()
        
        //UC: MAP the custom session configuration to VOC Factory
        let sessionConfiguration = URLSessionConfiguration.default
        VocServiceFactory.setupSessionConfiguration(sessionConfiguration)
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                let prettyJson = try? JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    
                    DDLogVerbose(prettyJson.debugDescription)
                    
                    let citiesDict = json as! NSDictionary
                    let cities = citiesDict.value(forKey:"cities") as! NSArray
                    UCServices.sharedInstance.cities = cities as! [NSDictionary]
                    
                    let executionTime = Date().timeIntervalSince(startDate)
                    let metrics:[String:String] = ["URL":getAllCitiesURL, "Time": String(executionTime)]
                    
                    self.delegate?.getAllCitiesAPIResponse!(placesDictionary: json as! NSDictionary, responseCode: response.statusCode, metrics:metrics)
                    
                } else {
                    
                }
                
            }
        })
        task.resume()
    }
    
    
    func requestPlacesForTheCity(cityId:Int){
        
        
        let getAllPlacesURL = "https://terraplanet.herokuapp.com/api/places/getAllPlacesOfCity?id="
        let getAllPlacesCompleteURL = "\(getAllPlacesURL)\(cityId)"
        let urlForTheRequest:URL? = URL(string:getAllPlacesCompleteURL)
        var request:URLRequest = URLRequest(url:urlForTheRequest!)
        request.httpMethod = "GET"
        
        var currentcity:NSDictionary? = nil
        for city in self.cities
        {
            if(city.value(forKey:"id") as! Int  == cityId){
                currentcity = city
            }
        }
        let currentCityMCopy:NSMutableDictionary? = NSMutableDictionary(dictionary:currentcity!)
        let startDate = Date()
        
        //UC: MAP the custom session configuration to VOC Factory
        let sessionConfiguration = URLSessionConfiguration.default
        VocServiceFactory.setupSessionConfiguration(sessionConfiguration)
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    let placesDict = json as! NSDictionary
                    DDLogVerbose(json.debugDescription)
                    
                    let places:NSArray? = placesDict.value(forKey:"places") as! NSArray?
                    currentCityMCopy?.setValue(places!, forKey:"places")
                    
                    self.selectedCity = currentCityMCopy! as NSDictionary
                    
                    let executionTime = Date().timeIntervalSince(startDate)
                    let metrics:[String:String] = ["URL":getAllPlacesCompleteURL, "Time": String(executionTime)]
                    
                    self.delegate?.retrievedPlacesForCity!(cityWithPlaces:currentCityMCopy!, metrics:metrics)
                    
                } else {
                    
                    self.delegate?.failedToRetrievePlacesForCityId!(cityWithEmptyPlaces:currentCityMCopy!)
                }
            }
        })
        task.resume()
        
        
    }
    
    func requestPlaceDetails(placeId:Int)
    {
        
        let getAllPlacesURL = "https://terraplanet.herokuapp.com/api/places/getPlaceDetails?id="
        let getPlaceDetailsCompleteURL = "\(getAllPlacesURL)\(placeId)"
        let urlForTheRequest:URL? = URL(string:getPlaceDetailsCompleteURL)
        var request:URLRequest = URLRequest(url:urlForTheRequest!)
        request.httpMethod = "GET"
        
        var currentPlace:NSDictionary? = nil
        let places:NSArray = self.selectedCity?.value(forKey: "places")  as! NSArray
        for place in places
        {
            let placeInContext:NSDictionary = place as! NSDictionary
            if(placeInContext.value(forKey:"id") as! Int  == placeId){
                currentPlace = placeInContext
            }
        }
        
        let currentPlaceMCopy:NSMutableDictionary? = NSMutableDictionary(dictionary:currentPlace!)
        
        let startDate = Date()
        
        //UC: MAP the custom session configuration to VOC Factory
        let sessionConfiguration = URLSessionConfiguration.default
        VocServiceFactory.setupSessionConfiguration(sessionConfiguration)
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    let placesDict = json as! NSDictionary
                    DDLogVerbose(json.debugDescription)
                    
                    let placeDetails:NSDictionary? = placesDict.value(forKey:"placeDetails") as! NSDictionary?
                    currentPlaceMCopy?.setValue(placeDetails!, forKey:"placeDetails")
                    
                    let placesMCopy:NSMutableArray? = NSMutableArray(array: places)
                    
                    //var currentPlaceOld:NSDictionary? = nil
                    var placeIndex = 0
                    
                    for i in 0..<placesMCopy!.count
                    {
                        
                        let placeInContext:NSDictionary = placesMCopy![i] as! NSDictionary
                        if(placeInContext.value(forKey:"id") as! Int  == placeId){
                            // currentPlaceOld = placeInContext
                            placeIndex = i
                            break
                        }
                    }
                    
                    placesMCopy?.replaceObject(at:placeIndex, with:currentPlaceMCopy!)
                    var currentCityMCopy:NSMutableDictionary? = nil
                    
                    if self.selectedCity != nil{
                       currentCityMCopy = NSMutableDictionary(dictionary:self.selectedCity!)
                       currentCityMCopy?.setValue(placesMCopy!, forKey:"places")

                    }
                    else{
                        return
                    }
                    
                    UCServices.sharedInstance.selectedCity = currentCityMCopy! as NSDictionary
                    UCServices.sharedInstance.selectedPlace = currentPlaceMCopy! as NSDictionary
                    //UCServices.sharedInstance.cities = cities as! [NSDictionary]
                    
                    let executionTime = Date().timeIntervalSince(startDate)
                    let metrics:[String:String] = ["URL":getPlaceDetailsCompleteURL, "Time": String(executionTime)]
                    
                    
                    self.delegate?.retrievedPlaceDetailsForThePlace!(placeId: placeId, metrics:metrics)
                    
                } else {
                    
                    self.delegate?.failedToRetrievePlaceDetailsForThePlace!(placeId: placeId)
                }
            }
        })
        task.resume()
    }
    
    
    func requestImagesFor(place:Int, city:Int)
    {
        var id:Int = 0
        
        if(place != 0)
        {
            id = place
        }
        else{
            id = city
        }
        
        let getAllCitiesURL = "https://terraplanet.herokuapp.com/api/media/getAllMediaByPlaceId?placeid=\(id)&type=image"
        let urlForTheRequest:URL? = URL(string:getAllCitiesURL)
        var request:URLRequest = URLRequest(url:urlForTheRequest!)
        request.httpMethod = "GET"
        
        let startDate = Date()
        
        //UC: MAP the custom session configuration to VOC Factory
        let sessionConfiguration = URLSessionConfiguration.default
        VocServiceFactory.setupSessionConfiguration(sessionConfiguration)
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    DDLogVerbose(json.debugDescription)
                    
                    
                    let mediaDict = json as! NSDictionary
                    print(mediaDict)
                    let mediaArray:NSArray = mediaDict.value(forKey:"media") as! NSArray
                    let imageURLs:NSMutableArray = NSMutableArray.init()
                    
                    for i in 1..<mediaArray.count
                    {
                        let mediaItem:NSDictionary = mediaArray[i] as! NSDictionary
                        let imageURL:String = mediaItem.value(forKey:"url") as! String
                        imageURLs.add(imageURL)
                    }
                    
                    let executionTime = Date().timeIntervalSince(startDate)
                    let metrics:[String:String] = ["URL":getAllCitiesURL, "Time": String(executionTime)]
                    
                    
                    self.delegate?.retrievedImages!(imageURLS: imageURLs, placeId: place,metrics:metrics)
                    
                }
                    
                else {
                }
            }
        })
        task.resume()
        
        
        
    }
    
    func issueImageRequestForAllTheImages(cities:NSArray){
        
        
        for i in 0 ..< cities.count  {
            let city = cities[i] as! NSDictionary
            let url = city.value(forKey:"thumburl")
            self.requestHeroImageForCities(ImageURL:url as! NSString, tag: i)
        }
    }
    
    
    func requestHeroImageForCities(ImageURL:NSString, tag:NSInteger)
    {
        
        let urlForTheRequest:URL? = URL(string:ImageURL as String)
        var request:URLRequest = URLRequest(url:urlForTheRequest!)
        request.httpMethod = "GET"
        
        
        //UC: MAP the custom session configuration to VOC Factory
        let sessionConfiguration = URLSessionConfiguration.default
        VocServiceFactory.setupSessionConfiguration(sessionConfiguration)
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    self.delegate?.imageReceivedForTheCity!(data: data as NSData, tag: tag)
                    
                } else {
                    self.delegate?.imageFailedForTheCity!(error: "Error while retrieving image for the tag")
                    
                }
            }
        })
        task.resume()
        
    }
    
    // MARK: - UI Services
    
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIView {
        
        let mainContainer: UIView = UIView(frame: viewContainer.bounds)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.black//UIColor.init(netHex: 0xFFFFFF)
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.darkText
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return mainContainer
    }
    
}


