//
//  ImageAPI.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/6/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

class ImageAPI {

 
    static let manager = ImageAPI()

    func getImages(ID: String, completionHandler: @escaping (Result<[ImageInfo], AppError>) -> ()) {
        let urlString = "https://api.foursquare.com/v2/venues/\(ID)/photos?client_id=\(Secrets.client)&client_secret=\(Secrets.key)&v=20191104"
        print("image \(urlString)")
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
                    let image = try JSONDecoder().decode(ImageModel.self, from: data)
                        completionHandler(.success(image.response.photos.items ))
                    } catch {
                        print(error)
                        completionHandler(.failure(.other(rawError: error)))
                    }
                }
            }
            
            
        }
    
    }
