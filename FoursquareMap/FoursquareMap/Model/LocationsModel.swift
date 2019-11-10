//
//  LocationsModel.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/4/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//
import MapKit
import CoreLocation
import Foundation



struct LocationsWrapper: Codable {
    let response: Venues
}
struct Venues: Codable{
    let venues: [Location]
}
class Location: NSObject, Codable, MKAnnotation{
    let id: String
    let name: String
    let location: Coords
    var address: String{
        return location.address
    }
    var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
     }
}
struct Coords: Codable {
    let lat: Double
    let lng: Double
    let address: String
}
