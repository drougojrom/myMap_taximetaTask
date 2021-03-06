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
    
    // region and location names
    var regionArrayHelper = [NSString]()
    var mapArrayHelper = [String]()

    // coordinates for first and second location
    var coordinateOne = CLLocationCoordinate2D()
    var coordinateTwo = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationLabel.text = mapArrayHelper.first!
        endLocationLabel.text = mapArrayHelper.last!

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(startLocationLabel.text!, completionHandler: { (placemarks, error) -> Void in
            
            if(error != nil) {
                print("\(error)")
            }
            
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.coordinateOne = coordinates
                let country1 = placemark.addressDictionary?["Country"] as? NSString
                self.regionArrayHelper.append(country1!)
                
                self.findLocations(self.coordinateOne, coordinateTwo: self.coordinateOne)
            }
        })
        
        self.mapView.delegate = self
        
    }
    
    // code string into location
    
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
                let country1 = placemark.addressDictionary?["Country"] as? NSString
                self.regionArrayHelper.append(country1!)

            }
        })
        
        secondGeocoder.geocodeAddressString(endLocationLabel.text!, completionHandler: { (placemarks, error) -> Void in
            
            if(error != nil) {
                print("\(error)")
            }
            
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.coordinateTwo = coordinates
                let country2 = placemark.addressDictionary?["Country"] as? NSString
                self.regionArrayHelper.append(country2!)
                
                self.findLocations(self.coordinateOne, coordinateTwo: self.coordinateTwo)
            }
        
        })
//        print(regionArrayHelper)
//        print(coordinateOne)
//        print(coordinateTwo)
        
    }
    
    // find locations using coordinates from geocoder
    func findLocations(coordinateOne: CLLocationCoordinate2D, coordinateTwo: CLLocationCoordinate2D) {
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        point1.coordinate = CLLocationCoordinate2DMake(coordinateOne.latitude, coordinateOne.longitude)
        //point1.coordinate = CLLocationCoordinate2DMake(54.5293000, 36.2754200)
        point1.title = mapArrayHelper.first!
        point1.subtitle = String(regionArrayHelper.first!)
        mapView.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(coordinateTwo.latitude, coordinateTwo.longitude)
        point2.title = mapArrayHelper.last!
        point2.subtitle = String(regionArrayHelper.last!)
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
    // draw the route
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
    // go to the previous viewController
    @IBAction func dismissViewController(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "This is your location"
        
        annotation.subtitle = "Lat. " + String(stringInterpolationSegment: latitude) + ", Lon. " + String(stringInterpolationSegment: longitude)
        
        mapView.addAnnotation(annotation)
    }
    
}




