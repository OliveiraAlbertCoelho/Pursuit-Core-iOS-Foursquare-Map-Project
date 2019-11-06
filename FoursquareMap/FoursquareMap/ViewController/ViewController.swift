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
    var currentLatLng = ""
    var location = [Location](){
        didSet{
            imageCollection.reloadData()
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
    let searchRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tagSearchBar()
        locationAuthorization()
        mapView.userTrackingMode = .follow
        setUpDelegate()
    }
    private func tagSearchBar(){
        venueSearchBar.tag = 0
        citySearchBar.tag = 1
    }
    private func loadData(search: String,latLng: String) {
        LocationsAPI.manager.getLocations(search: search, latLng: latLng){ (result) in
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
        imageCollection.delegate = self
        imageCollection.dataSource = self
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
          func createAnnotations(){
                   searchBar.resignFirstResponder()
                   let searchRequest = MKLocalSearch.Request()
                   searchRequest.naturalLanguageQuery = searchBar.text
                   let activeSearch = MKLocalSearch(request: searchRequest)
                   activeSearch.start { (response, error) in
                       if response == nil {
                           print(error!)
                       }else {
                           let lat = self.locationManager.location?.coordinate.latitude.description
                           let lng = self.locationManager.location?.coordinate.longitude.description
                           self.currentLatLng = "\(lat!),\(lng!)"
                           let annotations = self.mapView.annotations
                           self.mapView.removeAnnotations(annotations)
                        self.loadData(search: self.venueSearchBar.text!, latLng: self.currentLatLng)
                       }
                   }
            }
        
        switch searchBar.tag{
        case 0:
        createAnnotations()
        default:
            ZipCodeHelper.getLatLong(fromZipCode:citySearchBar.text!) { (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let lat, let long, let name):
                    self.currentLatLng = "\(lat.description),\(long.description)"
                    print(self.currentLatLng)
                    self.loadData(search: self.venueSearchBar.text!, latLng: self.currentLatLng)
                }
            }
        }
        
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return location.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        let data = location[indexPath.row]
        
        ImageAPI.manager.getImages(ID: data.id ){ (result) in
        switch result{
        case .failure(let error):
            print(error)
        case .success(let image):
            ImageManager.manager.getImage(urlStr: image[0].imageInfo) { (result) in
                DispatchQueue.main.async {
                switch result{
                    case .failure(let error):
                        print(error)
                    case .success(let image):
                        cell.venueImage.image = image
                    }
                }
            }
            }}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

