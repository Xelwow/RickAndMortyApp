//
//  CharacterInfoVC.swift
//  RickAndMortyApp
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation
import UIKit

class CharacterInfoVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var originLabel : UILabel!
    @IBOutlet weak var speciesLabel : UILabel!
    @IBOutlet weak var typeLabel : UILabel!
    
    @IBOutlet weak var mainInfoView: UIView!
    @IBOutlet weak var episodesView: UIView!
    
    @IBOutlet weak var episodesTableView : UITableView!
    
    @IBOutlet weak var episodesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var episodeViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var episodeViewTopToSafeZone: NSLayoutConstraint!
    
    @IBOutlet weak var downloadingEpisodesActivityIndicator : UIActivityIndicatorView!
    
    weak var charInfo : CharacterInfo?
    
    var episodesHidden = true
    var episodes : [EpisodeInfo] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.episodesTableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as! EpisodeCell
        cell.setInfo(info: episodes[indexPath.row])
        return cell
    }
    
    override func viewDidLoad() {
        if let charInfo = charInfo {
            nameLabel.text = charInfo.name
            statusLabel.text = charInfo.status
            locationLabel.text = charInfo.location.name
            originLabel.text = charInfo.origin.name
            speciesLabel.text = charInfo.species
            typeLabel.text = charInfo.type
            if let imageData = charInfo.imageData {
                let image = UIImage(data: imageData)
                imageView.image = image
            }
            getEpisodes()
        }
        let mainInfoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleMainInfoViewTap(_:)))
        let episodeViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleEpisodeViewTap(_:)))
        let episodeInfoSwipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        episodeInfoSwipeUpRecognizer.direction = .up
        let episodeInfoSwipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        episodeInfoSwipeDownRecognizer.direction = .down
        mainInfoView.addGestureRecognizer(mainInfoTapRecognizer)
        episodesView.addGestureRecognizer(episodeViewTapRecognizer)
        episodesView.addGestureRecognizer(episodeInfoSwipeUpRecognizer)
        episodesView.addGestureRecognizer(episodeInfoSwipeDownRecognizer)
        episodesView.layer.cornerRadius = 20
        
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
    }
    
    @objc func handleSwipe(_ sender : UISwipeGestureRecognizer){
        print("swipe")
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.up:
            if episodesHidden {
                showEpisodes()
            }
            break
        case UISwipeGestureRecognizer.Direction.down:
        if !episodesHidden {
            hideEpisodes()
        }
        break
        default:
            break
        }
    }
    
    @objc func handleMainInfoViewTap(_ sender : UITapGestureRecognizer? = nil){
        if !episodesHidden {
            hideEpisodes()
        }
    }
    
    @objc func handleEpisodeViewTap(_ sender : UITapGestureRecognizer? = nil){
        if episodesHidden {
            showEpisodes()
        }
    }
    
    func showEpisodes(){
        episodeViewTopToSafeZone.priority = .required
        episodeViewTop.priority = .defaultLow
        episodesTableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        episodesHidden = false
    }
    func hideEpisodes(){
        episodeViewTopToSafeZone.priority = .defaultLow
        episodeViewTop.priority = .required
        episodesTableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        episodesHidden = true
    }
    
    public func setCharacterInfo(character info : CharacterInfo){
        charInfo = info
    }
    
    private func getEpisodes() {
        for episode in charInfo!.episode {
            let url = URL(string: episode)!
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    let decodedData = try? decoder.decode(EpisodeInfo.self, from: data)
                    if let decodedData = decodedData {
                        DispatchQueue.main.async {
                            self.episodes.append(decodedData)
                            self.episodes.sort(by: {(first, second) in return first.id < second.id})
                            self.episodesTableView.reloadData()
                            self.downloadingEpisodesActivityIndicator.stopAnimating()
                            self.episodesTableView.tableFooterView?.isHidden = true
                        }
                        
                    }
                    else {
                        print("decoder returned nil")
                        return
                    }
                }
            }
            task.resume()
        }
    }
    
}
