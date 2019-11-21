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
    @IBOutlet weak var downloadMoreActivityIndicator : UIActivityIndicatorView!
    
    var characterList : [CharacterInfo] = []
    var nextPageURL : String = ""
    var isUpdating = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.charactersTableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        //cell.setInfo(name:  self.characterList[indexPath.row].name, imageUrl:  self.characterList[indexPath.row].image)
        cell.setInfo(info: self.characterList[indexPath.row])
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 && !isUpdating{
            print("update")
            isUpdating = true
            self.charactersTableView.tableFooterView!.isHidden = false
            self.downloadMoreActivityIndicator.startAnimating()
            downloadPageData(shouldDownloadNewData: characterList.count > 0 ? true : false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.delegate = self
        charactersTableView.dataSource = self        
        
        charactersTableView.refreshControl = UIRefreshControl()
        charactersTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating data")
        charactersTableView.refreshControl?.addTarget(self, action: #selector(self.refreshTableData), for: .valueChanged)
        charactersTableView.refreshControl?.backgroundColor = charactersTableView.backgroundColor!
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
            url = URL(string: ApiInfo.getPage)
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
                        if self.charactersTableView.tableFooterView!.isHidden{
                            self.charactersTableView.refreshControl?.endRefreshing()
                        }
                        else {
                            self.downloadMoreActivityIndicator.stopAnimating()
                            self.charactersTableView.tableFooterView?.isHidden = true
                            self.isUpdating = false
                        }
                        self.charactersTableView.reloadData()
                        self.charactersTableView.isHidden = false
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
    
    func loadNewPage(){
        downloadPageData(shouldDownloadNewData: true)
    }
    
    func getCharacterList(){
        downloadPageData(shouldDownloadNewData: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "characterInfo" {
            (segue.destination as! CharacterInfoVC).setCharacterInfo(character: (sender as! CharacterCell).characterInfo!)
        }
    }

}

