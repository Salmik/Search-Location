//
//  ViewController.swift
//  SearchingLocations
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

final class ViewController: UIViewController {
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
  private let panel = FloatingPanelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.addSubview(mapView)
        floatingPanelConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    private func floatingPanelConfigure() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
    }

}

// MARK:- SearchViewControllerDelegate
extension ViewController: SearchViewControllerDelegate {
    
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith: CLLocationCoordinate2D?) {
        mapView.removeAnnotations(mapView.annotations)
        
        guard let coordinates = didSelectLocationWith else { return }
        
        panel.move(to: .tip, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        mapView.addAnnotation(pin)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinates,
                                             span: MKCoordinateSpan(
                                                latitudeDelta: 0.7,
                                                longitudeDelta: 0.7)),
                          animated: true)
    }
}
