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

    func getLocations(completionHandler: @escaping (Result<[Venues], AppError>) -> ()) {
        let urlString = "https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=\(Secrets.client)&client_secret=\(Secrets.key)&v=20191104"
       
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
                        completionHandler(.success(local.response ))
                    } catch {
                        print(error)
                        completionHandler(.failure(.other(rawError: error)))
                    }
                }
            }
            
            
        }
    
    }
