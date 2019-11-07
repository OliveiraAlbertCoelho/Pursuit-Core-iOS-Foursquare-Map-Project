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
    var locations = [Location](){
        didSet{
            imageCollection.reloadData()
            locations.forEach { (location) in
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                annotation.coordinate = location.coordinate
                mapView.addAnnotation(annotation)
            }
            //            mapView.addAnnotations(locations.filter{$0.hasValidCoordinates})
            
        }
        
    }
    @IBAction func ResultVcAction(_ sender: UIButton) {
        let resultVC = storyboard?.instantiateViewController(identifier: "result")as! ResultListVC
        resultVC.venues = locations
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
    
    let searchRadius: CLLocationDistance = 400
    @IBOutlet weak var venueSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpDelegate()
        locationAuthorization()
        mapView.userTrackingMode = .follow
    }
    
    private func loadData(search: String,latLng: String) {
        DispatchQueue.main.async {
            LocationsAPI.manager.getLocations(search: search, latLng: latLng){ (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let venue):
                    self.locations = venue
                }
            }
        }
    }
    private func setUpDelegate(){
        mapView.delegate = self
        locationManager.delegate = self
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        venueSearchBar.showsCancelButton = false
        venueSearchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = citySearchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            if response == nil {
                print(error!)
            }else {
                let lat = response?.boundingRegion.center.latitude
                let lng = response?.boundingRegion.center.longitude
                self.currentLatLng = "\(lat!),\(lng!)"
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                let coordinateRegion = MKCoordinateRegion.init(center: newAnnotation.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.loadData(search: self.venueSearchBar.text!, latLng: self.currentLatLng)
                print(coordinateRegion.center)
            }
        }
              searchBar.resignFirstResponder()
    }
    
}
extension ViewController: MKMapViewDelegate{
    
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        let data = locations[indexPath.row]
        ImageAPI.manager.getImages(ID: data.id ){ (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                    cell.venueImage.image = UIImage(named: "noImage")
                case .success(let image):
                    
                    if image.count != 0{
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
                    }}}}
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
    
}

