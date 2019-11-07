//
//  AddCollectionVC.swift
//  FoursquareMap
//
//  Created by albert coelho oliveira on 11/7/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class AddCollectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

    }
    @IBOutlet weak var userText: UITextField!
    private func setUpView(){
        self.navigationItem.title = "Create Collection"
        self.navigationItem.rightBarButtonItem = CreateButton
    }
        lazy var CreateButton: UIBarButtonItem = {
               var saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(saveAction(sender:)))
               return saveButton
           }()
    
        @IBAction func saveAction(sender: UIBarButtonItem) {
            if let text = userText.text{
            let collection = CollectionModel(name: text, location: nil, ImageInfo: nil)
            try? CollectionPersistence.manager.saveData(info: collection)
            }else {
                let alert = UIAlertController(title: "", message: "Please input a name", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: true)
            }
            navigationController?.popViewController(animated: true)
        
    }}
