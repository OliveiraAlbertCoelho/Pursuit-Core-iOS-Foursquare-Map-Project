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
    let venues: [Location]?
}
class Location: NSObject, Codable, MKAnnotation{
    let id: String?
    let name: String?
    let location: Coords?
    var address: String{
        if let location = location?.address{
            return location
        }else {
        return ""
        }}
    var coordinate: CLLocationCoordinate2D{
        if let lat = location?.lat {
            if let lng = location?.lng{
                 return CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
        }
        return CLLocationCoordinate2D()
     }
}
struct Coords: Codable {
    let lat: Double
    let lng: Double
    let address: String?
}
