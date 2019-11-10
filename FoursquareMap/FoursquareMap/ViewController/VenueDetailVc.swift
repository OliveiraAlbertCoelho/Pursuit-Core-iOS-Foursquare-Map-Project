//
//  VenueDetailVc.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/7/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class VenueDetailVc: UIViewController {
    // MARK: - Variables
    var venue: Location?
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    private func setUpView(){
        guard let venueInfo = venue else {
            venueName.text = "No venue name"
            locationLabel.text = "No location info"
            return}
        
        guard let safeImage = venueInfo.image else {
            venueImage.image = UIImage(named: "noImage")
            return
        }
        getImage(Url: safeImage.imageInfo)
        venueName.text = venueInfo.name
        locationLabel.text = "Address: \(venueInfo.addres)"
    }
    
    
    private func getImage (Url: String){
        ImageManager.manager.getImage(urlStr: Url) { (Result) in
            DispatchQueue.main.async {
                switch Result{
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.venueImage.image = image
                }
            }
            
        }
    }
    @IBAction func locationAction(_ sender: UIButton) {
    }
    
    @IBOutlet weak var venueImage: UIImageView!
    
    @IBAction func addButton(_ sender: UIButton) {
        let addVc = storyboard?.instantiateViewController(identifier: "addVenueVc")as! AddVenueToCollectionVC
        addVc.venue = venue
        self.navigationController?.pushViewController(addVc, animated: true)
    }
}
