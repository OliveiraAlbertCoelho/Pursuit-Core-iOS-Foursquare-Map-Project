//
//  ImagePersistence.swift
//  Photo-Journal-Project
//
//  Created by albert coelho oliveira on 10/3/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

struct CollectionPersistence{
    private init(){}
    static let manager = CollectionPersistence()
    private let persistenceHelper = PersistenceHelper<CollectionModel>(fileName: "collectionData.plist")
    
    func getData() throws -> [CollectionModel]{
        return try persistenceHelper.getObjects().reversed()
    }
    func saveData(info: CollectionModel) throws{
        try persistenceHelper.save(newElement: info)
    }
    func deleteData(Int: Int) throws{
        try persistenceHelper.delete(num: Int)
    }
    func editData(Int: Int, newElement: CollectionModel) throws{
        try persistenceHelper.edit(num: Int, newElement: newElement)
    }
    
    
}
