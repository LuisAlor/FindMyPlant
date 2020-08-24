//
//  FavoritesViewController + UITableView.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 23.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlantsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseIdentifier) as! FavoritesTableViewCell
        cell.tag = indexPath.row
        cell.thumbnailImage.image = nil
        cell.thumbnailImage.layer.cornerRadius = 10
        
        cell.commonNameTextLabel.text = favoritePlantsInfo[indexPath.row].commonName?.sentenceCase() ?? "Unknown"
        cell.scientificTextLabel.text = favoritePlantsInfo[indexPath.row].scientificName.sentenceCase()
        cell.imageActivityViewIndicator.startAnimating()
        
        if let imageURLString = favoritePlantsInfo[indexPath.row].imageURL{
            _ = TrefleAPiClient.downloadImage(imageURL: URL(string: imageURLString)!) { (image, error) in
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
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.Segues.favoritesToDetails.identifier, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            unsetFavoritePlant(forRow: indexPath.row)
            favoritePlantsInfo.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        default: () // Unsupported
        }
    }
    
}
