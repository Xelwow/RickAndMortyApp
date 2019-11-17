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
    
    var characterList : [CharacterInfo] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.charactersTableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        cell.nameLabel.text = self.characterList[indexPath.row].name
        return cell
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        
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

}

