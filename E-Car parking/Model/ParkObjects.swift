//
//  ParkObjects.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 30/03/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import Foundation
import MapKit

class ParkObejcts: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D 
    var address : String = ""
    var title : String? = ""
    var LAT : String = ""
    var LON : String = ""
    var typeOfData : String = ""
   
    
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D, LAT: String, LON: String, typeOfData: String) {
        self.title = title
        self.address = address
        self.LAT = LAT
        self.LON = LON
        self.coordinate = coordinate
        self.typeOfData = typeOfData
        super.init()
    }
    var subtitle: String? {
        return address
    }
    
    // markerTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    var markerTintColor: UIColor  {
        switch typeOfData {
        case "userCreated":
            return .red
        case "verified":
            return .green
        default:
            return .red
        }
    }
    
    
}
