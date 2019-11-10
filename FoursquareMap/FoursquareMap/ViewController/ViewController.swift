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
    // MARK: - Variables
    private let locationManager = CLLocationManager()
    var currentLatLng = ""
    var annotations = [MKAnnotation]()
    var select: Location?
    @IBOutlet weak var venueSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var imageCollection: UICollectionView!
    var locations = [Location](){
        didSet{
            imageCollection.reloadData()
            locations.forEach { (location) in
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                annotation.coordinate = location.coordinate
                annotations.append(annotation)
                mapView.addAnnotation(annotation)
            }
            self.mapView.showAnnotations(self.annotations, animated: true)
        }
    }
    //MARK: - Buttons And ViewDidLoad
    @objc func passData(sender: UIButton){
                     let detailVC = storyboard?.instantiateViewController(identifier: "detailVc")as! VenueDetailVc
                     detailVC.venue = select
                     self.navigationController?.pushViewController(detailVC, animated: true)
           }
    
    @IBAction func ResultVcAction(_ sender: UIButton) {
        if annotations.isEmpty{
            let alert = UIAlertController(title: "", message: "Please search for a valid venue", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true)
        }else {
            let resultVC = storyboard?.instantiateViewController(identifier: "result")as! ResultListVC
            resultVC.venues = locations
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        locationAuthorization()
    }
    // MARK: - Regular Functions
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
            mapView.userTrackingMode = .follow
            mapView.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
//MARK: CLLocationDelegate functions
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
//MARK: UISearchBarDelegate functions
extension ViewController: UISearchBarDelegate{
    
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
                self.annotations.removeAll()
                self.loadData(search: self.venueSearchBar.text!, latLng: self.currentLatLng)
            }
        }
        searchBar.resignFirstResponder()
    }
    
}
//MARK: MKMapViewDelegate Functions
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
     let infoButton = UIButton(type: .detailDisclosure)
          view.rightCalloutAccessoryView = infoButton
            infoButton.addTarget(self, action: #selector(passData(sender:)), for: .touchUpInside)
            let  selected = self.locations.filter({$0.name == view.annotation?.title})
        select = selected.first
        }
        
    }

//MARK: UICollectionViewDelegate Functions
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if locations.isEmpty && !currentLatLng.isEmpty{
                     let alert = UIAlertController(title: "", message: "Seems we have no results for that search, Please try something else", preferredStyle: .alert)
                     let cancel = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
                     alert.addAction(cancel)
                     present(alert,animated: true)
        }
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
                    ImageManager.manager.getImage(urlStr: image.first?.imageInfo ?? "") { (result) in
                        DispatchQueue.main.async {
                            switch result{
                            case .failure(let error):
                                print(error)
                                cell.venueImage.image = UIImage(named: "noImage")
                            case .success(let image):
                                cell.venueImage.image = image
                            }
                        }
                    }
                }
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let annotation = annotations[indexPath.row]
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
}
