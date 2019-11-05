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
    let searchRadius: CLLocationDistance = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setUpDelegates()
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
}

