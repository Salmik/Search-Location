//
//  LocationManager.swift
//  SearchingLocations
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    public func findLocations(_ query: String, completion: @escaping (([Location]) -> Void )) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query) { placemarks, error in
            guard let places = placemarks, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap { place in
                
                var name = ""
                
                if let locationName = place.name {
                    name += locationName
                }

                if let regionName = place.administrativeArea {
                    name += ", \(regionName)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                let result = Location(title: name, coordinate: place.location?.coordinate)
                return result
            }
            
            completion(models)
        }
    }
    
}
