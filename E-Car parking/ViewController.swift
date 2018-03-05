//
//  ViewController.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 04/03/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
   //Global variables and constants
    var pElements: [MapClass] = []
    let regionRadius: CLLocationDistance = 1000 //Sets the radius til 1 km in the map.
    
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets the default location. This to test the app.
        let initialLocation = CLLocation(latitude: 55.742527, longitude: 12.317348)
        centerMapOnLocation(location: initialLocation)
       
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(pElements)
        
//        //Testing with info on th map
//
//                // show artwork on map
//                let element = MapClass(title: "Ezenta",locationName: "Hørkær 14",coordinate: CLLocationCoordinate2D(latitude: 55.717771, longitude: 12.437287))
//                mapView.addAnnotation(element)
        
        
        
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
        // 1
        guard let fileName = Bundle.main.path(forResource: "elements", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        let validWorks = works.flatMap { MapClass(json: $0) }
        pElements.append(contentsOf: validWorks)
        print("print")
        print(pElements[0].locationName)
    }
}

