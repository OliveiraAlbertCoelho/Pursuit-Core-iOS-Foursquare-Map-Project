//
//  ViewController.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/4/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import MapKit
import CoreLocation
import Foundation
import UIKit

class ViewController: UIViewController {
    private let locationManager = CLLocationManager()
    
    var location = [Location](){
        didSet{
            mapView.addAnnotations(location.filter{$0.hasValidCoordinates})
        }
        
    }
    var searchString: String? = nil {
           didSet{
               mapView.addAnnotations(location.filter{$0.hasValidCoordinates})
           }
       }
    
    @IBOutlet weak var venueSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var imageCollection: UICollectionView!
    let initialLocation = CLLocation(latitude: 40.742054, longitude: -73.739417)
    let searchRadius: CLLocationDistance = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationAuthorization()
           mapView.userTrackingMode = .follow
        setUpDelegate()
    }
    private func loadData(search: String) {
        LocationsAPI.manager.getLocations(search: search){ (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let venue):
                self.location = venue
            }
        }
    }
    private func setUpDelegate(){
        citySearchBar.delegate = self
        venueSearchBar.delegate = self
    }
    private func locationAuthorization(){
          let status = CLLocationManager.authorizationStatus()
          switch status {
          case .authorizedAlways, .authorizedWhenInUse:
              mapView.showsUserLocation = true
              locationManager.requestLocation()
              locationManager.startUpdatingLocation()
              locationManager.desiredAccuracy = kCLLocationAccuracyBest
          default:
              locationManager.requestWhenInUseAuthorization()
          }
      }
}
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New Location: \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
}
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        venueSearchBar.showsCancelButton = true
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        venueSearchBar.showsCancelButton = false
        venueSearchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         let activityIndicator = UIActivityIndicatorView()
         activityIndicator.center = self.view.center
         activityIndicator.startAnimating()
         self.view.addSubview(activityIndicator)
         searchBar.resignFirstResponder()
         let searchRequest = MKLocalSearch.Request()
         searchRequest.naturalLanguageQuery = searchBar.text
         let activeSearch = MKLocalSearch(request: searchRequest)
         activeSearch.start { (response, error) in
             activityIndicator.stopAnimating()
             
             if response == nil {
                 print(error)
             }else {
                 let annotations = self.mapView.annotations
                 self.mapView.removeAnnotations(annotations)
                 self.loadData(search: searchBar.text!)
             }
         }
     }

}

