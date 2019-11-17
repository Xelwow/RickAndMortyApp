//
//  CharacterInfoViewController.swift
//  RickAndMortyApp
//
//  Created by Admin on 17.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation
import UIKit

class CharacterInfoViewController : UITableViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var originLabel : UILabel!
    @IBOutlet weak var genderLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var speciesLabel : UILabel!
    @IBOutlet weak var typeLabel : UILabel!
    
    weak var charInfo : CharacterInfo?
    
    override func viewDidLoad() {
        if let charInfo = charInfo {
            nameLabel.text = charInfo.name
            genderLabel.text = charInfo.gender
            originLabel.text = charInfo.origin.name
            locationLabel.text = charInfo.location.name
            statusLabel.text = charInfo.status
            speciesLabel.text = charInfo.species
            typeLabel.text = charInfo.type            
            if let image = UIImage(data: charInfo.imageData!){
                imageView.image = image
            }
        }
    }
    
    public func SetData(character info : CharacterInfo){
        self.charInfo = info
        
    }
}
