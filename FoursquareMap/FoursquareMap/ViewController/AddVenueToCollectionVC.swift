//
//  AddCollectionVC.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/7/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class AddVenueToCollectionVC: UIViewController {
    //Mark: - Variables
       @IBOutlet weak var venueCollection: UICollectionView!
    var collections: [CollectionModel]?{
        didSet{
            venueCollection.reloadData()
        }
    }
    
    var venue: Location?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadData()
    }
   //MARK: - View Functions
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
 //MARK: - CollectionView Extensions
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
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selected = collections![indexPath.row]
        if selected.checkVenues(Id: venue!.id!){
            let alert = UIAlertController(title: "", message: "You already have this venue saved", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel){ (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancel)
            present(alert,animated: true)
        }else {
            if  var venueUnwrap = selected.venues{
                venueUnwrap.append(venue!)
                let newVenues = CollectionModel(name: selected.name, venues: venueUnwrap)
                selected = newVenues
            }else {
                let newVenues = CollectionModel(name: selected.name, venues: [venue!])
                selected = newVenues
            }
            let alert = UIAlertController(title: "", message: "Saved", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
                      alert.addAction(cancel)
                      present(alert,animated: true)
            try? CollectionPersistence.manager.editData(Int: indexPath.row, newElement: selected)
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
}
