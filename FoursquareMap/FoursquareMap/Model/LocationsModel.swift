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
    let response: [Venues]
}
struct Venues: Codable{
    let venues: [Locations]
}
class Locations: NSObject, Codable, MKAnnotation{
    let id: String
    let name: String
    private let position: String
    @objc var coordinate: CLLocationCoordinate2D{
         let latLong = position.components(separatedBy: ",").map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}.map{Double($0)}
         guard latLong.count == 2,
             let lat = latLong[0],
             let long = latLong[1] else {return CLLocationCoordinate2D.init()}
         return CLLocationCoordinate2D(latitude: lat, longitude: long)
     }
     var hasValidCoordinates: Bool{
         return coordinate.latitude != 0 && coordinate.longitude != 0
         
     }
    
}
