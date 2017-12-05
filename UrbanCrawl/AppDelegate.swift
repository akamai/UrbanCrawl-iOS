//
//  AppDelegate.swift
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
import CocoaLumberjack
import VocSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,VocServiceDelegate {

    var window: UIWindow?
    var ddFileLogger:DDFileLogger? = nil
    var akaService:AkaWebAccelerator?;


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //UC: Registering MAP SDK with the licence key.
        
        do {
            let options:Dictionary<String,String> = ["license":"NOW_REFER_TO_INFO_PLIST"]
            try self.akaService =   VocServiceFactory.createAkaWebAccelerator(with:self , delegateQueue: OperationQueue.main, options: nil)
            
            if (self.akaService?.state == VOCServiceState.notRegistered) {
                // service needs registering
                print("SDK user not registered, starting registration flow")
                return true
            }
            
            //UC:service already registered
            print("SDK user registered, starting normal flow")
            
            //UC: Logging one time event using MAP SDK
            self.akaService?.logEvent("APP_LAUNCHED")
            //UC: Example for logging the time based events.
            self.akaService?.startEvent("HOME_SCREEN_LOAD_TIME")
            self.akaService?.stopEvent("HOME_SCREEN_LOAD_TIME")


        } catch {
            print("Could not create service")
            return false
        }
        
        //UC: Setting the time based debug console.
        self.akaService?.setDebugConsoleLog(true)


        //UC: UrbanCrawl uses Lumberjack for logging.
        self.ddFileLogger = DDFileLogger() // File Logger
        self.ddFileLogger?.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        self.ddFileLogger?.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(ddFileLogger!)

        DDLogVerbose("Log Initialized for UrbanCrawl")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //UC:MAPSDK vocservice delegate methods.
    
    func vocService(_ vocService: VocService, didBecomeNotRegistered info: [AnyHashable : Any]) {
        print("didBecomeNotRegistered \(vocService), \(info)")
    }
    
    func vocService(_ vocService: VocService, didFailToRegister error: Error) {
        print("didFailToRegister \(vocService), \(error)")
    }
    
    func vocService(_ vocService: VocService, didRegister info: [AnyHashable : Any]) {
        print("didRegister \(vocService), \(info)")
    }
    
    func vocService(_ vocService: VocService, didInitialize info: [AnyHashable : Any]) {
        print("didInitialize \(vocService), \(info)")
    }
    
    func testQuality()->Int {
        
        if(self.akaService!.state == VOCServiceState.notRegistered) {

            print("User not registered")
            return -1
        }
        
        let networkQuality:VocNetworkQuality = self.akaService!.networkQuality()!;
        switch (networkQuality.qualityStatus) {
        case .poor:
        return 1
        //Exit download
        case .good:
        return 2
        //Throttle download
        case .excellent:
        return 3
        //Download content
        case .unknown:
        return 4
        case .notReady:
        return 5
        }
    }
    
    
    func subscribeToSegment(segmentName:String){
        
        //UC: Subscribe to the city which the user is planning to travel.
        let segments:Set = [segmentName]
        self.akaService?.subscribeSegments(segments)
        
    }

}

