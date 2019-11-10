//
//  AddCollectionVC.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/7/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class AddVenueToCollectionVC: UIViewController {
    var collections: [CollectionModel]?{
        didSet{
            venueCollection.reloadData()
            
        }
    }
    @IBOutlet weak var venueCollection: UICollectionView!
    var venue: Location?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadData()
    }

    private func setUpView(){
        venueCollection.delegate = self
        venueCollection.dataSource = self
    }
    
    private func loadData(){
      do {
             collections = try CollectionPersistence.manager.getData()
        print("im a collection\(collections?.count)")
              }catch{
                  print(error)
              }
          }
}
    
extension AddVenueToCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collect = collections{
          return collect.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCollect", for: indexPath) as! AddCollectionViewCell
        if let data = collections{
         let cellData = data[indexPath.row]
            cell.collectionName.text = cellData.name
            cell.backgroundColor = .blue
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selected = collections![indexPath.row]
        if var venueUnwrap = selected.venues{
            venueUnwrap.append(venue!)
            let newVenues = CollectionModel(name: selected.name, venues: venueUnwrap)
                 selected = newVenues
        }else {
            let newVenues = CollectionModel(name: selected.name, venues: [venue!])
            selected = newVenues
        }
        
        
        try? CollectionPersistence.manager.editData(Int: indexPath.row, newElement: selected)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
}
