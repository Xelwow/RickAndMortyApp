//
//  CharacterInfoVC.swift
//  RickAndMortyApp
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation
import UIKit

class CharacterInfoVC : UIViewController {
    @IBOutlet weak var mainInfoView: CharacterMainInfoView!
    @IBOutlet weak var episodesView: EpisodeView!
    @IBOutlet weak var episodeViewTop: NSLayoutConstraint!
    @IBOutlet weak var episodeViewTopToSafeZone: NSLayoutConstraint!
    
    weak var charInfo : CharacterInfo?
    
    override func viewDidLoad() {
        if let charInfo = charInfo {
            mainInfoView.setInfo(character: charInfo)
            episodesView.getEpisodes(character: charInfo)
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
        //episodesView.layer.cornerRadius = 20
    }
    
    @objc func handleSwipe(_ sender : UISwipeGestureRecognizer){
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.up:
            if episodesView.episodesHidden {
                showEpisodes()
            }
            break
        case UISwipeGestureRecognizer.Direction.down:
            if !episodesView.episodesHidden {
            hideEpisodes()
        }
        break
        default:
            break
        }
    }
    
    @objc func handleMainInfoViewTap(_ sender : UITapGestureRecognizer? = nil){
        if !episodesView.episodesHidden {
            hideEpisodes()
        }
    }
    
    @objc func handleEpisodeViewTap(_ sender : UITapGestureRecognizer? = nil){
        if episodesView.episodesHidden {
            showEpisodes()
        }
    }
    
    func showEpisodes(){
        episodeViewTopToSafeZone.priority = .required
        episodeViewTop.priority = .defaultLow
        episodesView.episodesTableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        episodesView.episodesHidden = false
    }
    func hideEpisodes(){
        episodeViewTopToSafeZone.priority = .defaultLow
        episodeViewTop.priority = .required
        episodesView.episodesTableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        episodesView.episodesHidden = true
    }
    
    public func setCharacterInfo(character info : CharacterInfo){
        charInfo = info
    }
    
}
