//
//  favoriteVenueVC.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/9/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class FavoriteVenueVC: UIViewController {
    //MARK: Variables
    var collection: CollectionModel?{
        didSet{
             venues = collection!.venues
            print("ahhhhh\( venues?.count ?? 200)")
        }
    }
    var venues: [Location]?{
        didSet{
        }
    }
    
    @IBOutlet weak var resultTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resultTable.reloadData()
    }
    private func setUpVC(){
        resultTable.delegate = self
        resultTable.dataSource = self
                 
    }
}
  //MARK: UITable Extensions
    extension FavoriteVenueVC: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let venue = venues else {
                let alert = UIAlertController(title: "", message: "You have no saved venues in this collection", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel) { (alert) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancel)
                
                present(alert, animated: true)
               
                return 0
            }
            
            return venue.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = resultTable.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
            let data = venues![indexPath.row]
            cell.textLabel?.text = data.name
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = storyboard?.instantiateViewController(identifier: "detailVc")as! VenueDetailVc
            detailVC.venue = venues![indexPath.row]
               self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
