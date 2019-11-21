//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Admin on 15.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import UIKit

class CharactersListVC: UITableViewController{
    
    @IBOutlet weak var downloadMoreActivityIndicator : UIActivityIndicatorView!
    
    var characterList : [CharacterInfo] = []
    var nextPageURL : String = ""
    var isUpdating = false
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        //cell.setInfo(name:  self.characterList[indexPath.row].name, imageUrl:  self.characterList[indexPath.row].image)
        cell.setInfo(info: self.characterList[indexPath.row])
        
        return cell
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 && !isUpdating{
            isUpdating = true
            self.tableView.tableFooterView!.isHidden = false
            self.downloadMoreActivityIndicator.startAnimating()
            downloadPageData(shouldDownloadNewData: characterList.count > 0 ? true : false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating data")
        tableView.refreshControl?.addTarget(self, action: #selector(self.refreshTableData), for: .valueChanged)
        tableView.refreshControl?.backgroundColor = tableView.backgroundColor!
    }
    
    @objc func refreshTableData(){
        downloadPageData(shouldDownloadNewData: false)
    }
    
    func downloadPageData(shouldDownloadNewData : Bool){
        var url : URL?
        if shouldDownloadNewData {
            if nextPageURL.count > 0 {
                url = URL(string: nextPageURL)
            }
            else {
                return
            }
            
        }
        else{
            url = URL(string: "https://rickandmortyapi.com/api/character/")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                self.downloadPageData(shouldDownloadNewData: shouldDownloadNewData)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(GetPageResponse.self, from: data)
                if let decoded = decoded {
                    DispatchQueue.main.async {
                        if shouldDownloadNewData {
                            self.characterList.append(contentsOf: decoded.results)
                        }
                        else {
                            self.characterList = decoded.results
                            
                        }
                        if self.tableView.tableFooterView!.isHidden{
                            self.tableView.refreshControl?.endRefreshing()
                        }
                        else {
                            self.downloadMoreActivityIndicator.stopAnimating()
                            self.tableView.tableFooterView?.isHidden = true
                            self.isUpdating = false
                        }
                        self.tableView.reloadData()
                        self.nextPageURL = decoded.info.next
                        
                    }
                    return
                }
                else {
                    print("decoder.decode returned nil")
                    self.downloadPageData(shouldDownloadNewData: shouldDownloadNewData)
                    return
                }
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

