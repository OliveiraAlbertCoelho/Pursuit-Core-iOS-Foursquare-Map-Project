//
//  ResultListVC.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/5/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class ResultListVC: UIViewController {
    // MARK: - Variables
    var venues: [Location]?{
        didSet{
            self.venues![0].name
        }
    }
    @IBOutlet weak var resultTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTable.delegate = self
        resultTable.dataSource = self
        resultTable.reloadData()
    }
}

// MARK: - UITableViewDelegate Extension
extension ResultListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
        let data = venues![indexPath.row]
        cell.venueName.text = data.name
        cell.venueImage.image = UIImage(named: "noImage")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let detailVc = storyboard?.instantiateViewController(identifier: "detailVc")as! VenueDetailVc
         detailVc.venue = venues![indexPath.row]
         self.navigationController?.pushViewController(detailVc, animated: true)
    }
}
