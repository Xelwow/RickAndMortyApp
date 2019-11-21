//
//  EpisodeView.swift
//  RickAndMortyApp
//
//  Created by Admin on 21.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import UIKit

class EpisodeView : UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var episodesTableView : UITableView!
    @IBOutlet weak var downloadingEpisodesActivityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var failedToDownloadLabel : UILabel!
    
    @IBInspectable public var cornerRadius : CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    weak var characterInfo : CharacterInfo?
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
    
    
    @objc func retryDownloadEpisodes(){
        if let characterInfo = characterInfo {
            getEpisodes(character: characterInfo)
        }
    }
    
    public func getEpisodes(character info : CharacterInfo){
        self.characterInfo = info
        for episode in info.episode {
            let url = URL(string: episode)!
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.failedToDownloadLabel.isHidden = false
                        self.episodesTableView.refreshControl?.endRefreshing()
                        self.episodesTableView.refreshControl = UIRefreshControl()
                        self.episodesTableView.refreshControl?.addTarget(self, action: #selector(self.retryDownloadEpisodes), for: .valueChanged)
                        self.episodesTableView.refreshControl?.backgroundColor = self.episodesTableView.backgroundColor!
                    }
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
                            self.episodesTableView.refreshControl?.endRefreshing()
                            self.episodesTableView.tableFooterView?.isHidden = true
                        }
                    }
                    else {
                        print("decoder returned nil")
                        DispatchQueue.main.async {
                            self.failedToDownloadLabel.isHidden = false
                            self.downloadingEpisodesActivityIndicator.stopAnimating()
                            self.episodesTableView.refreshControl = UIRefreshControl()
                            self.episodesTableView.refreshControl?.addTarget(self, action: #selector(self.retryDownloadEpisodes), for: .valueChanged)
                            self.episodesTableView.refreshControl?.backgroundColor = self.episodesTableView.backgroundColor!
                        }
                        return
                    }
                }
            }
            task.resume()
        }
        
    }
}
