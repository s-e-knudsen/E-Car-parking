//
//  MapClass.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 05/03/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import Foundation
import MapKit

class MapClass: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    //    // markerTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    //    var markerTintColor: UIColor  {
    //        switch discipline {
    //        case "Monument":
    //            return .red
    //        case "Mural":
    //            return .cyan
    //        case "Plaque":
    //            return .blue
    //        case "Sculpture":
    //            return .purple
    //        default:
    //            return .green
    //        }
    //    }
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }

    
    var subtitle: String? {
        return locationName
    }
    

    
}
