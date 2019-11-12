//
//  LocationsAPI.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/4/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

class LocationsAPI {

 
    static let manager = LocationsAPI()

    func getLocations(search: String,latLng: String, completionHandler: @escaping (Result<[Location], AppError>) -> ()) {
        let fixedString = search.replacingOccurrences(of: " ", with: "-")
        let urlString = "https://api.foursquare.com/v2/venues/search?ll=\(latLng)&client_id=\(Secrets.client)&client_secret=\(Secrets.key)&v=20191104&query=\(fixedString)&limit=2&radius=1000"
        print(urlString)
       
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
                      return
                  }
            NetworkHelper.manager.performDataTask(withUrl: url , andMethod: .get) { (result) in
                switch result {
                case .failure(let error) :
                    completionHandler(.failure(error))
                case .success(let data):
                    do {
                    let local = try JSONDecoder().decode(LocationsWrapper.self, from: data)
                        completionHandler(.success(local.response.venues! ))
                    } catch {
                        print(error)
                        completionHandler(.failure(.other(rawError: error)))
                    }
                }
            }
            
            
        }
    
    }
