//
//  File.swift
//  SearchingLocations
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import Foundation
import CoreLocation

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith: CLLocationCoordinate2D?)
}
