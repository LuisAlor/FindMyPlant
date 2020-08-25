//
//  FavoritesViewController + UITableView.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 23.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Return the number of rows for the table obtained from favoritePlantsInfo array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlantsInfo.count
    }
    
    //Generate/Reuse a cell for the tableView and set all the information for the plant
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseIdentifier) as! FavoritesTableViewCell
        //Assign a tag to cell to keep track for setting correct image
        cell.tag = indexPath.row
        //Reset thumbnail image to nil for not showing old images when cell is reused
        cell.thumbnailImage.image = nil
        //Set corner radius of the imageView
        cell.thumbnailImage.layer.cornerRadius = 10
        
        //Set the commonNameTextLabel and scientificTextLabel text
        cell.commonNameTextLabel.text = favoritePlantsInfo[indexPath.row].commonName?.sentenceCase() ?? "Unknown"
        cell.scientificTextLabel.text = favoritePlantsInfo[indexPath.row].scientificName.sentenceCase()
        
        //Start animating the activity indicator for the thumbnailImage
        cell.imageActivityViewIndicator.startAnimating()
        
        //If the imageURL field is not empty then download image or look for it in the cache
        if let imageURLString = favoritePlantsInfo[indexPath.row].imageURL{
            _ = TrefleAPiClient.downloadImage(imageURL: URL(string: imageURLString)!) { (image, error) in
                if error == nil{
                    if let image = image{
                        DispatchQueue.main.async {
                            //Verify if the tag corresponds to the cell we want to set the image
                            if cell.tag == indexPath.row {
                                //Set the image from the data downloaded or cache
                                cell.thumbnailImage.image = image
                                //Stop animating the activity indicator
                                cell.imageActivityViewIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
        } else {
            //If no image was found for the field imageURL then stop animating activity indicator
            cell.imageActivityViewIndicator.stopAnimating()
            //Set thumbnailImage to a "No Image Found" placeholder
            cell.thumbnailImage.image = #imageLiteral(resourceName: "NoImageFound")
        }
                
        return cell
    }
    
    //Process the plant selected and trigger segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Save the indexPath from the plant selected
        selectedIndex = indexPath.row
        //Deselect the row for not autoselecting when going back
        tableView.deselectRow(at: indexPath, animated: true)
        //Perform segue to DetailsVC
        performSegue(withIdentifier: Constants.Segues.favoritesToDetails.identifier, sender: nil)
    }
    
    //Edit style, delete the row with swipe style only
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //Remove the plant from favorites in Firestore
            unsetFavoritePlant(forRow: indexPath.row)
            //Remove from local data the plant
            favoritePlantsInfo.remove(at: indexPath.row)
            //Start tableView updates
            tableView.beginUpdates()
            //Delete the row with fade animation at the swiped left indexPath
            tableView.deleteRows(at: [indexPath], with: .fade)
            //Stop tableView updates
            tableView.endUpdates()
        default: () // Unsupported
        }
    }
    
}
