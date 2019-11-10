//
//  CollectionModel.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/8/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

struct CollectionModel: Codable{
    let name: String?
    var venues: [Location]?
    func checkVenues (Id: String) -> Bool{
        guard let venue = venues else{return false}
        if venue.isEmpty {
            return false
        }
        var check = false
        venue.forEach { (Location)  in
            if Location.id == Id{
                check = true
            }
        }
        return check
    }
}
