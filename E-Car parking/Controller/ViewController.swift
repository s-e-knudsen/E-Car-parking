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
   
    //MARK: - Global variables and constants

    var pElementsArray: [ParkObejcts] = [ParkObejcts]() //Array to parkings that is used for annonations on mapkit.
    let locationManager = CLLocationManager()
    var myLocation = MKUserLocation()
    var pinColor : MKPinAnnotationView = MKPinAnnotationView()
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var mapSelectionBar: UISegmentedControl!
    @IBOutlet weak var myLocationIcon: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkContainer: UIView!
    @IBOutlet weak var addParkingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set deligate to this class of the mapkit view.
        mapView.delegate = self

       // pinColor.pinTintColor = UIColor.blue
        
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
        
        
    }

    func initsetup() {
        retrieveDataFromDB()
        mapView.addAnnotations(pElementsArray)
        
        //Initial setup for the map span and user location.
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
    
        if locationManager.location?.coordinate != nil {
            let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
            mapView.setRegion(region, animated: true)
        } else {
            print("Error: did not get data")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    //MARK: - Annotation - placing obects on the map. 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKMarkerAnnotationView = MKMarkerAnnotationView()
        guard let MyAnnotation = annotation as? ParkObejcts else {return nil}
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MyAnnotation.address) as? MKMarkerAnnotationView {
                view = dequeuedView
            }else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MyAnnotation.address)
            }
        
        if MyAnnotation.markerTintColor == UIColor.green {
            view.glyphTintColor = UIColor.black
            
        } else {
            view.glyphTintColor = UIColor.white
        }
        
        view.markerTintColor = MyAnnotation.markerTintColor
        view.glyphText = "P"
        
        return view

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
        
        addParkingButton.isEnabled = false
        
        //Add code for adding parking here!
        let longDuble : Double = (locationManager.location?.coordinate.longitude)!
        let latDuble : Double = (locationManager.location?.coordinate.latitude)!
        
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
        
        //Waits 90 secons and the call the enableParkingButton method.
        Timer.scheduledTimer(timeInterval: 90, target: self, selector: #selector(ViewController.enableParkingButtons), userInfo: nil, repeats: false)
    }
    
    @IBAction func deleteParking(_ sender: UIButton) {
        //Add code for delete (request) for parking here!
    }
    
    @IBAction func myLocationPressed(_ sender: UIBarButtonItem) {
        mapView .setCenter(myLocation.coordinate, animated: true)
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
    
    @objc func enableParkingButtons () {
        
        addParkingButton.isEnabled = true
        
    }
    
    //MARK: - Database write and read methods
    
    func sendDataToDB(LON: String, LAT: String, Address: String) {
        let parkingDB = Database.database().reference().child("userCreated")
        let parkingDictionary = ["Title": "Parking", "Address": Address, "LON": LON, "LAT": LAT, "typeOfData": "userCreated"]
        
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
            let parkType = snapshotValue["typeOfData"]!
            let coordinate = CLLocationCoordinate2D(latitude: Double(parkLAT)!, longitude: Double(parkLON)!)
            

            let parkInformation = ParkObejcts(title: parkTitle, address: parkAddress, coordinate: coordinate, LAT: parkLAT, LON: parkLON, typeOfData: parkType)

       

            print(parkTitle, parkAddress, parkLAT, parkLON)
            print("Print UserCreatedDB")
            print(userCreatedParkingDB)
            self.pElementsArray.append(parkInformation)
            self.mapView.addAnnotations(self.pElementsArray)

        }
        verfiedParkingDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>

            let parkAddress = snapshotValue["Address"]!
            let parkTitle = snapshotValue["Title"]!
            let parkLON = snapshotValue["LON"]!
            let parkLAT = snapshotValue["LAT"]!
            let parkType = snapshotValue["typeOfData"]!
            let coordinate = CLLocationCoordinate2D(latitude: Double(parkLAT)!, longitude: Double(parkLON)!)



            let parkInformation = ParkObejcts(title: parkTitle, address: parkAddress, coordinate: coordinate, LAT: parkLAT, LON: parkLON, typeOfData: parkType)


            print(parkTitle, parkAddress, parkLAT, parkLON)
            self.pElementsArray.append(parkInformation)

            self.mapView.addAnnotations(self.pElementsArray)

        }
    }
}

