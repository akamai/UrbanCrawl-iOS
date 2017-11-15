//
//  PlanTravelViewController.swift
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

class PlanTravelViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var cityTextField:UITextField?
    @IBOutlet weak var startDateField:UITextField?
    @IBOutlet weak var endDateField:UITextField?
    var cityPickerView:UIPickerView? = nil;
    var selectedTextField:Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y+44)
        gradientLayer.frame.size =  CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradientLayer.colors = [UIColor.purple.withAlphaComponent(0.7).cgColor,UIColor.purple.withAlphaComponent(0.3).cgColor,UIColor.purple.withAlphaComponent(0.3).cgColor] //Use diffrent colors
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0.7)
     //  self.view.layer.addSublayer(gradientLayer)
        
        
        
        
        let toolBar:UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 50))
        toolBar.barStyle = .default
        
        let doneButton:UIBarButtonItem = UIBarButtonItem.init(title:"Done", style:.done, target: self, action: #selector(self.doneWithEditing))
        toolBar.items = [doneButton]
        
        let cityPicker:UIPickerView = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: self.view.frame.size.height*0.30))
        cityPicker.delegate = self
        cityPicker.dataSource = self
        cityTextField?.inputView = cityPicker
        cityTextField?.inputAccessoryView = toolBar
        self.cityPickerView  = cityPicker
        
        let startDatePicker:UIDatePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: self.view.frame.size.height*0.30))
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(dateClicked), for:.valueChanged)
        startDateField?.inputView = startDatePicker
        startDateField?.inputAccessoryView = toolBar

        endDateField?.inputView = startDatePicker
        endDateField?.inputAccessoryView = toolBar

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneClicked(sender:Any?)
    {
        
        self.dismiss(animated:true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK picker datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return UCServices.sharedInstance.cities.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let city:NSDictionary = UCServices.sharedInstance.cities[row] as NSDictionary
        let cityName:String = city.value(forKey: "name") as! String
        return cityName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView == self.cityPickerView)
        {
            let city:NSDictionary = UCServices.sharedInstance.cities[row] as NSDictionary
            let cityName:String = city.value(forKey: "name") as! String

            self.cityTextField?.text = cityName
        }
        
    }
    
    
    @IBAction func doneWithEditing(sender:Any?){
        
                self.view.endEditing(true)
    }
    
    @IBAction func dateClicked(sender:Any?){
        
        let picker:UIDatePicker = sender as! UIDatePicker
        let date:Date = picker.date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let dateString = formatter.string(from: date)
        if(self.startDateField?.isFirstResponder == true)
        {
            self.startDateField?.text = dateString
        
        }
        else{
            
            self.endDateField?.text = dateString
            
        }
    }
    
    @IBAction func saveButtonClicked(sender:Any?)
    {
        
        let alert = UIAlertController(title: "UrbanCrawl", message: "Thanks! We have noted down your travel plan!!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.destructive, handler: ({(alert: UIAlertAction!) in         self.dismiss(animated:true, completion: nil)
        })))
        self.present(alert, animated: true, completion: nil)
        

    }

}
