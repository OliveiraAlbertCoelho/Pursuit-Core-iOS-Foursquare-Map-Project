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
}
