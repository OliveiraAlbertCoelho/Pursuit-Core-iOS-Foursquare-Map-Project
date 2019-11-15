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
    static func getVenues(from jsonData: Data) -> Venues? {
           do {
               let data = try JSONDecoder().decode(Venues.self, from: jsonData)
               return data
           } catch {
               print("Decoding error: \(error)")
               return nil
           }
       }
}
struct Coords: Codable {
    let lat: Double
    let lng: Double
    let address: String?
}
struct DataToTest{
static func getDataFromBundle(withName name: String, andType type: String) -> Data {
    guard let pathToData = Bundle.main.path(forResource: name, ofType: type) else {
        fatalError("\(name).\(type) file not found")
    }
    let internalUrl = URL(fileURLWithPath: pathToData)
    do {
        let data = try Data(contentsOf: internalUrl)
        return data
    }
    catch {
        fatalError("An error occurred: \(error)}")
    }
}
}
