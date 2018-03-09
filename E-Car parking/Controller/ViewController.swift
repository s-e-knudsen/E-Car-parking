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
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(pElements)
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Toolbar transarent
        self.toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.toolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        
        initsetup()
    }

    func initsetup() {
        //Initial setup for the map span and user location.
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
    
        if locationManager.location?.coordinate != nil {
            let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
            mapView.setRegion(region, animated: true)
        } else {
            print("did not get data")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView .setCenter(userLocation.coordinate, animated: true)
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

