//
//  LocationsAPI.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/4/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation


import Foundation




class CardAPI {

 
    static let manager = CardAPI()

    func getWeather(completionHandler: @escaping (Result<[flashCard], AppError>) -> ()) {
        
        let urlString = "https://5daf8b36f2946f001481d81c.mockapi.io/api/v2/cards"
       
       
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
                    let card = try JSONDecoder().decode(CardsWrapper.self, from: data)
                        completionHandler(.success(card.cards))
                    } catch {
                        print(error)
                        completionHandler(.failure(.other(rawError: error)))
                    }
                }
            }
            
            
        }
    
    }
