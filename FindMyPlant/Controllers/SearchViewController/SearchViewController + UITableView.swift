//
//  SearchViewController + UITableView.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantsSearchResult != nil ? plantsSearchResult.data.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier) as! SearchTableViewCell
        cell.tag = indexPath.row
        cell.thumbnailImage.image = nil
        cell.thumbnailImage.layer.cornerRadius = 10
        
        cell.commonNameTextLabel.text = plantsSearchResult.data[indexPath.row].commonName?.sentenceCase() ?? "Unknown"
        cell.scientificNameLabel.text = plantsSearchResult.data[indexPath.row].scientificName.sentenceCase()
        cell.imageActivityViewIndicator.startAnimating()
        
        if let imageURLString = plantsSearchResult.data[indexPath.row].imageURL{
            currentDownloadImageTask = TrefleAPiClient.downloadImage(imageURL: URL(string: imageURLString)!) { (image, error) in
                if error == nil{
                    if let image = image{
                        DispatchQueue.main.async {
                            if cell.tag == indexPath.row {
                                cell.thumbnailImage.image = image
                                cell.imageActivityViewIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
        } else {
            cell.imageActivityViewIndicator.stopAnimating()
            cell.thumbnailImage.image = #imageLiteral(resourceName: "NoImageFound")
        }
        
        //If there is a current image download task append it
        if let currentDownloadImageTask = currentDownloadImageTask {
            downloadImgURLSessionTasks.append(currentDownloadImageTask)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.Segues.searchToDetails.identifier, sender: nil)
    }
    
}
