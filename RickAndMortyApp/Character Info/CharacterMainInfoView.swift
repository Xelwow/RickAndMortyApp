//
//  CharacterMainInfoView.swift
//  RickAndMortyApp
//
//  Created by Admin on 21.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import UIKit

class CharacterMainInfoView : UIView {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var originLabel : UILabel!
    @IBOutlet weak var speciesLabel : UILabel!
    @IBOutlet weak var typeLabel : UILabel!
    
    public func setInfo(character info : CharacterInfo){
        nameLabel.text = info.name
        statusLabel.text = info.status
        locationLabel.text = info.location.name
        originLabel.text = info.origin.name
        speciesLabel.text = info.species
        typeLabel.text = info.type
        if let imageData = info.imageData {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
}
