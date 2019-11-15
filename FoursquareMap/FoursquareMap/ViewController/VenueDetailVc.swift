//
//  VenueDetailVc.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/7/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import MapKit
import UIKit
import Foundation
import CoreLocation
class VenueDetailVc: UIViewController {
    // MARK: - Variables
    var venue: Location?{
        didSet{
            getImage(Id: (venue?.id)!)
        }
    }
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var venueAddress: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    private func setUpView(){
        guard let location = venue else {
            locationName.text = "No venue info"
            return
        }
        locationName.text = location.name
        venueAddress.text = "Address: \(location.address)"
    }
//     MARK: - Regular View Functions
    private func getImage (Id: String){
        ImageAPI.manager.getImages(ID: Id ){ (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                    self.venueImage.image = UIImage(named: "noImage")
                case .success(let image):
                    ImageManager.manager.getImage(urlStr: image.first?.imageInfo ?? "") { (result) in
                        DispatchQueue.main.async {
                            switch result{
                            case .failure(let error):
                                print(error)
                                self.venueImage.image = UIImage(named: "noImage")
                            case .success(let image):
                                self.venueImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }

        

    // MARK: - Button Actions
    @IBAction func locationAction(_ sender: UIButton) {
        guard let location = venue else {
            sender.isHidden = false
            return}
        let coordinate = location.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    @IBAction func addButton(_ sender: UIButton) {
        let addVc = storyboard?.instantiateViewController(identifier: "addVenueVc")as! AddVenueToCollectionVC
        addVc.venue = venue
        self.navigationController?.pushViewController(addVc, animated: true)
    }
}
