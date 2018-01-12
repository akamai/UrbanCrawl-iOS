//
//  SetttingsTableViewController.swift
//  UrbanCrawl
//
//  Created by Gokul Sengottuvelu on 10/4/17.
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

class SetttingsTableViewController: UITableViewController {
    
    @IBOutlet weak var devSwitch:UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UrbanCrawl Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch(indexPath.section) {
        case 0: return  100
        case 1: return  50
        case 2: return  50
        case 3: return  50
        case 4: return  50
        
        default :return 0
            
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        switch(section) {
            
        case 0: return  35
        case 1: return  35
        case 2: return  35
        case 3: return  35
        case 4: return  35
     
        default :return 40.0
            
        }
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch(section) {
        case 0:return "About the App"
        case 1:return "Version of the App"
        case 2:return "Email"
        case 3:return "Enable the Developer mode"
        case 4:return "Find logs in our Debug console"
        default :return nil
            
        }
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var returnCell:UITableViewCell? = nil
        let cellIdentifier:String
        
        switch(indexPath.section)
        {
            
        case 0:
        cellIdentifier = "AboutApp"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell!
        else{
             DDLogVerbose("ssd")
             return returnCell!
        }
        returnCell = cell
        case 1:
            cellIdentifier = "NormalCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell!
                else{
                    DDLogVerbose("ssd")
                    return returnCell!
            }
            
            
            cell.textLabel?.text = "1.0.1"
            returnCell = cell
        case 2:
            cellIdentifier = "NormalCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell!
                else{
                    DDLogVerbose("ssd")
                    return returnCell!
            }
            
            
            cell.textLabel?.text = "devrel@akamai.com"
            returnCell = cell
        case 3:
            cellIdentifier = "developermode"
         guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DevModeTableViewCell
                else{
                    DDLogVerbose("ssd")
                    return returnCell!
            }
            
            cell.devModeSwitch?.setOn(UCServices.sharedInstance.developerMode, animated:false)
            
            returnCell = cell
        case 4:
            cellIdentifier = "console"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell!
                else{
                    DDLogVerbose("ssd")
                    return returnCell!
            }
            
            returnCell = cell
            
        
        default:
        returnCell = nil
        }
        return returnCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(indexPath.section == 4){
        self.performSegue(withIdentifier: "logsSegue", sender: nil)
        }
        
    }
    
    @IBAction func developerModeChanged(sender:Any?)
    {
        if(UCServices.sharedInstance.developerMode == true)
        {
            UCServices.sharedInstance.developerMode = false
        }
        else{
            UCServices.sharedInstance.developerMode = true
        }
        
    }
    
    

}
