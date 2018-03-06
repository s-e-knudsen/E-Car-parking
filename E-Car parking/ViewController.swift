//
//  ViewController.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 04/03/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   //Global variables and constants
    var pElements: [MapClass] = []
    let regionRadius: CLLocationDistance = 1000 //Sets the radius til 1 km in the map.
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets the default location. This to test the app.
        let initialLocation = CLLocation(latitude: 55.742527, longitude: 12.317348)
        centerMapOnLocation(location: initialLocation)
       
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(pElements)
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Function to center on the map with the location.
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //Coverting JSON data into array used for annoneations in mapview
    func loadInitialData() {
        // Loading JSON file into variables.
        guard let fileName = Bundle.main.path(forResource: "elements", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        //Convert JSON elements one-by-one and use the MapClass attributes to add to array
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let works = dictionary["data"] as? [[Any]]
            else { return }
        let validWorks = works.flatMap { MapClass(json: $0) }
        pElements.append(contentsOf: validWorks)

    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
}

