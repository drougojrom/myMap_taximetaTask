//
//  ChooseLocationViewController.swift
//  myMap
//
//  Created by Roman Ustiantcev on 11/05/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ChooseLocationViewController: UIViewController {

    @IBOutlet weak var finishLocationFiled: UITextField!
    @IBOutlet weak var startLocationField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    // save locations
    var arrayHelper = [String]()
    
    // bool for button
    
    var buttonEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrayCount(arrayHelper)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // check if we have valid data
    @IBAction func addressEntered(sender: UIButton) {
        
        let startString = startLocationField.text
        arrayHelper.append(startString!)

        let finishString = finishLocationFiled.text
        arrayHelper.append(finishString!)
        
        arrayCount(arrayHelper)
        viewDidLoad()
        
    }
    
    // clear for new location
    @IBAction func clearLocations(sender: UIButton) {
        
        finishLocationFiled.text = ""
        startLocationField.text = ""
        arrayHelper = []
        viewDidLoad()
        
    }
    
    @IBAction func getDirections(sender: UIButton) {
        view.endEditing(true)
        
        buttonEnabled = false
        goButton.enabled = buttonEnabled
        
    }
    
    func arrayCount(var arrayHelper: [String]) -> Bool {
        if (arrayHelper.count < 2) || arrayHelper.first == "" || arrayHelper.last == "" || arrayHelper.first == arrayHelper.last {
            arrayHelper.removeAll()
            goButton.enabled = buttonEnabled
            return false
        } else {
            buttonEnabled = true
            goButton.enabled = buttonEnabled
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowLocation" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let destinationController = navigationController.topViewController as! MapViewController
            
            destinationController.mapArrayHelper.appendContentsOf(arrayHelper)
        }
    }
}
