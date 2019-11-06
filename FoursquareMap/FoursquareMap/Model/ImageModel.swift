//
//  ImageModel.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/6/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

struct ImageModel: Codable {
    let response: Photos
}
struct Photos: Codable{
    let photos: Items
}
struct Items: Codable {
    let items: [ImageInfo]
}
struct ImageInfo: Codable{
    let prefix: String
    let suffix: String
    var imageInfo: String {
        return "\(prefix)original\(suffix)"
    }
}
