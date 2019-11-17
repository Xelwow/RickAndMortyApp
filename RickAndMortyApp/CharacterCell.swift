//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Admin on 17.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation
import UIKit

class CharacterCell : UITableViewCell {
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    var characterInfo : CharacterInfo?
    
    public func setInfo(info : CharacterInfo){
        self.characterInfo = info
        self.nameLabel.text = info.name
        
        if let imageData = info.imageData {
            let image = UIImage(data : imageData)
            if let image = image {
                characterImageView.image = image
            }
        }
        else{
            setImage(imageUrl: info.image)
        }
    }
    
    public func setInfo(name : String, imageUrl : String){
            self.nameLabel.text = name
            setImage(imageUrl: imageUrl)
    }
    
    private func setImage(imageUrl : String){
        characterImageView.image = nil
        let url = URL(string: imageUrl)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                let image = UIImage(data: data)
                if let image = image {
                    DispatchQueue.main.async {
                        print("setting image")
                        self.characterImageView.image = image
                        self.characterInfo?.imageData = data
                    }
                }
            }
            else {
                print()
                return
            }
            
            
            
        }
        task.resume()
    }
}
