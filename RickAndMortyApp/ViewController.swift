//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Admin on 15.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var charactersTableView : UITableView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    
    var characterList : [CharacterInfo] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.charactersTableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        //cell.setInfo(name:  self.characterList[indexPath.row].name, imageUrl:  self.characterList[indexPath.row].image)
        cell.setInfo(info: self.characterList[indexPath.row])
        return cell
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        charactersTableView.isHidden = true
        
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        
        getCharacterList()
        // Do any additional setup after loading the view.
    }
    
    func getCharacterList(){
        let url = URL(string: ApiInfo.getPage)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard data != nil else{
                print("guard let data error")
                return
            }
            let decoder = JSONDecoder()
            let decoded = try? decoder.decode(GetPageResponse.self, from: data!)
            if let decoded = decoded {
                DispatchQueue.main.async {
                    self.characterList.append(contentsOf: decoded.results)
                    self.charactersTableView.reloadData()
                    self.charactersTableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            else {
                print("decoder.decode returned nil")
                return
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "characterInfo" {
            (segue.destination as! CharacterInfoVC).setCharacterInfo(character: (sender as! CharacterCell).characterInfo!)
        }
    }

}

