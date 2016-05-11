//
//  ViewController.swift
//  myMap
//
//  Created by Roman Ustiantcev on 11/05/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var startLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var myRoute : MKRoute?
    
    var mapArrayHelper = [String]()

    var coordinateOne = CLLocationCoordinate2D()
    var coordinateTwo = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationLabel.text = mapArrayHelper.first!
        endLocationLabel.text = mapArrayHelper.last!
        
        self.mapView.delegate = self
    }
    
    @IBAction func getYourRoute(sender: UIButton) {
        
        let geocoder = CLGeocoder()
        let secondGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(startLocationLabel.text!, completionHandler: { (placemarks, error) -> Void in
            
            if(error != nil) {
                print("\(error)")
            }
            
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.coordinateOne = coordinates
            }
        })
        
        secondGeocoder.geocodeAddressString(endLocationLabel.text!, completionHandler: { (placemarks, error) -> Void in
            
            if(error != nil) {
                print("\(error)")
            }
            
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.coordinateTwo = coordinates
            }
        
        })
        print(coordinateOne)
        print(coordinateTwo)
        findLocations(coordinateOne, coordinateTwo: coordinateTwo)
    }
    
    func findLocations(coordinateOne: CLLocationCoordinate2D, coordinateTwo: CLLocationCoordinate2D) {
    
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        point1.coordinate = CLLocationCoordinate2DMake(coordinateOne.latitude, coordinateOne.longitude)
        //point1.coordinate = CLLocationCoordinate2DMake(54.5293000, 36.2754200)
        point1.title = "Kaluga"
        point1.subtitle = "Russia"
        mapView.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(coordinateTwo.latitude, coordinateTwo.longitude)
        point2.title = "Maloyaroslavest"
        point2.subtitle = "Russia"
        mapView.addAnnotation(point2)
        
        
        mapView.centerCoordinate = point1.coordinate
        mapView.delegate = self
        
        //Span of the map
        mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        let markLocationOne = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markLocationTwo = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markLocationOne)
        directionsRequest.destination = MKMapItem(placemark: markLocationTwo)
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculateDirectionsWithCompletionHandler({ (response: MKDirectionsResponse?, error: NSError?) -> Void in
            
            if (error != nil) {
                print("\(error)")
            } else {
                self.myRoute = response?.routes.last
                self.mapView.addOverlay((self.myRoute?.polyline)!)
            }
        })
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor.redColor()
            polylineRenderer.lineWidth = 3
        }
        
        return polylineRenderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissViewController(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}




