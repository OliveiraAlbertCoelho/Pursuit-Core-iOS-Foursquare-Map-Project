//
//  VenueDetailVc.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/7/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class VenueDetailVc: UIViewController {
    
    var venue: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    private func setUpView(){
        venueImage.image = UIImage(named: "noImage")
        venueName.text = venue?.name
    }
    
    
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var venueName: UILabel!
    @IBAction func addButton(_ sender: UIButton) {
    }
}
