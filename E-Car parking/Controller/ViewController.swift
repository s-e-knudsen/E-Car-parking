//
//  ViewController.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 04/03/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


enum MapType: NSInteger {
    case StandardMap = 0
    case SatelliteMap = 1
    case HybridMap = 2
}


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   
   
    //Global variables and constants
    //var pElements: [MapClass] = [MapClass]()
    var pElementsArray: [ParkObejcts] = [ParkObejcts]() //Array to test.
    
    
    let locationManager = CLLocationManager()
    var myLocation = MKUserLocation()
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var mapSelectionBar: UISegmentedControl!
    @IBOutlet weak var myLocationIcon: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        mapView.delegate = self
        //loadInitialData() // was from json file
        //mapView.addAnnotations(pElements)
        mapView.addAnnotations(pElementsArray)
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Mapvie defalt setup
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsCompass = true
        
        //Toolbar transarent
        self.toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.toolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        
        
        //Make park container with rouded edges
        parkContainer.layer.cornerRadius = 10
        
        // Call init setup
        initsetup()
        //sendDataToDB() // This is only for testing
        retrieveDataFromDB()
    }

    func initsetup() {
        //Initial setup for the map span and user location.
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
    
        if locationManager.location?.coordinate != nil {
            let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
            mapView.setRegion(region, animated: true)
 //           print("Cordinate is:")
//            let longTest : Double = (locationManager.location?.coordinate.latitude)!
//            let longTestS : String = String(longTest)
//            print(longTestS)
//            print(locationManager.location?.coordinate.longitude)
//            print(locationManager.location?.coordinate.latitude)
        } else {
            print("did not get data")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        myLocation = userLocation
        //mapView .setCenter(userLocation.coordinate, animated: true)
    }

    @IBAction func mapControl(_ sender: UISegmentedControl) {
        //Setting the map control view.
        //This refer to the enum above.
        switch sender.selectedSegmentIndex {
        case  MapType.StandardMap.rawValue:
            mapView.mapType = .standard
            self.myLocationIcon.tintColor = UIColor.black
            self.mapSelectionBar.tintColor = UIColor.black
        case MapType.SatelliteMap.rawValue:
            mapView.mapType = .satellite
            self.myLocationIcon.tintColor = UIColor.white
            self.mapSelectionBar.tintColor = UIColor.white
        case MapType.HybridMap.rawValue:
            mapView.mapType = .hybrid
            self.myLocationIcon.tintColor = UIColor.white
            self.mapSelectionBar.tintColor = UIColor.white
        default:
            break
        }
    }
    @IBAction func addParking(_ sender: UIButton) {
        //Add code for adding parking here!
        let longDuble : Double = (locationManager.location?.coordinate.longitude)!
        let latDuble : Double = (locationManager.location?.coordinate.latitude)!
        //let myCoordinate = CLLocationCoordinate2D(latitude: latDuble, longitude: longDuble)
        
        let addLON = String(longDuble)
        let addLAT = String(latDuble)
        var newPAddress : String = ""
        
        //Alert box to insert address
        var newAddress = UITextField()
        let alert = UIAlertController(title: "Input address", message: "Write the address - optional", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            newPAddress = newAddress.text!
            
            self.sendDataToDB(LON: addLON, LAT: addLAT, Address: newPAddress)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            newAddress = field
            newAddress.placeholder = "Add Address"
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func deleteParking(_ sender: UIButton) {
        //Add code for delete (request) for parking here!
    }
    
    @IBAction func myLocationPressed(_ sender: UIBarButtonItem) {
        mapView .setCenter(myLocation.coordinate, animated: true)
    }
    
    //Coverting JSON data into array used for annoneations in mapview
//    func loadInitialData() {
//        // Loading JSON file into variables.
//        guard let fileName = Bundle.main.path(forResource: "elements", ofType: "json")
//            else { return }
//        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
//        //Convert JSON elements one-by-one and use the MapClass attributes to add to array
//        guard
//            let data = optionalData,
//            let json = try? JSONSerialization.jsonObject(with: data),
//            let dictionary = json as? [String: Any],
//            let works = dictionary["data"] as? [[Any]]
//            else { return }
//        let validWorks = works.compactMap { MapClass(json: $0) }
//        pElements.append(contentsOf: validWorks)
//
//    }
    
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
    
    //MARK: - Database write and read methods
    
    func sendDataToDB(LON: String, LAT: String, Address: String) {
        let parkingDB = Database.database().reference().child("userCreated")
        let parkingDictionary = ["Title": "Parking", "Address": Address, "LON": LON, "LAT": LAT]
        
        parkingDB.childByAutoId().setValue(parkingDictionary) { (error, referance) in
            if error != nil {
                print(error!)
            } else {
                print("Data is saved to DB")
            }
            
        }
    }
    
    func retrieveDataFromDB() {

        let userCreatedParkingDB = Database.database().reference().child("userCreated")
        let verfiedParkingDB = Database.database().reference().child("Verified")
        
        userCreatedParkingDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>

            let parkAddress = snapshotValue["Address"]!
            let parkTitle = snapshotValue["Title"]!
            let parkLON = snapshotValue["LON"]!
            let parkLAT = snapshotValue["LAT"]!
            let coordinate = CLLocationCoordinate2D(latitude: Double(parkLAT)!, longitude: Double(parkLON)!)
            

            let parkInformation = ParkObejcts(title: parkTitle, address: parkAddress, coordinate: coordinate, LAT: parkLAT, LON: parkLON)


            print(parkTitle, parkAddress, parkLAT, parkLON)
            self.pElementsArray.append(parkInformation)
            self.mapView.addAnnotations(self.pElementsArray)

        }
        verfiedParkingDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let parkAddress = snapshotValue["Address"]!
            let parkTitle = snapshotValue["Title"]!
            let parkLON = snapshotValue["LON"]!
            let parkLAT = snapshotValue["LAT"]!
            let coordinate = CLLocationCoordinate2D(latitude: Double(parkLAT)!, longitude: Double(parkLON)!)
            
            
            let parkInformation = ParkObejcts(title: parkTitle, address: parkAddress, coordinate: coordinate, LAT: parkLAT, LON: parkLON)
            
            
            print(parkTitle, parkAddress, parkLAT, parkLON)
            self.pElementsArray.append(parkInformation)
            self.mapView.addAnnotations(self.pElementsArray)
            
        }
    }
}

