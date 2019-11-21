//
//  EpisodeCell.swift
//  RickAndMortyApp
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    
    func setInfo(info : EpisodeInfo){
        episodeLabel.text = info.episode
        nameLabel.text = info.name
        airDateLabel.text = info.air_date
    }
}
