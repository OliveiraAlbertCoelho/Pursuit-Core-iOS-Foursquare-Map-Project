//
//  CollectionsViewController.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/7/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {

    var collection = [CollectionModel](){
        didSet{
            collectionsTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = saveButton
        collectionsTable.delegate = self
        collectionsTable.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
           loadData()
    }
    @IBOutlet weak var collectionsTable: UICollectionView!
    
    lazy var saveButton: UIBarButtonItem = {
           var saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(saveAction(sender:)))
           return saveButton
       }()
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let addVc = storyboard?.instantiateViewController(identifier: "addVc")as! AddCollectionVC
              self.navigationController?.pushViewController(addVc, animated: true)
    }
    private func loadData(){
         do {
            collection = try CollectionPersistence.manager.getData()
             }catch{
                 print(error)
             }
         }
    }

extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionsTable.dequeueReusableCell(withReuseIdentifier: "collecCell", for: indexPath) as! VenueCollectionCell
        let data = collection[indexPath.row]
        print(data.venues)
        cell.collectionName.text = data.name
        cell.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favVC = storyboard?.instantiateViewController(identifier: "favVC")as! FavoriteVenueVC
        favVC.collection = collection[indexPath.row]
           self.navigationController?.pushViewController(favVC, animated: true)
    }
}
