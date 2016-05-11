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
    
    var arrayHelper = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addressEntered(sender: UIButton) {
        
        let startString = startLocationField.text
        arrayHelper.append(startString!)

        let finishString = finishLocationFiled.text
        arrayHelper.append(finishString!)
        
    }
    
    @IBAction func clearLocations(sender: UIButton) {
        
        finishLocationFiled.text = ""
        startLocationField.text = ""
        arrayHelper = []
        
    }
    
    @IBAction func getDirections(sender: UIButton) {
        view.endEditing(true)
        performSegueWithIdentifier("ShowLocation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowLocation" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let destinationController = navigationController.topViewController as! MapViewController
            
            destinationController.mapArrayHelper.appendContentsOf(arrayHelper)
        }
    }
}
