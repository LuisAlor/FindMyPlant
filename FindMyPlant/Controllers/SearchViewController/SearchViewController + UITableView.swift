//
//  SearchViewController + UITableView.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Return the number of rows for the table obtained from plantsSearchResult array if nil return 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantsSearchResult != nil ? plantsSearchResult.data.count : 0
    }
    
    //Generate/Reuse a cell for the tableView and set all the information for the plant
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier) as! SearchTableViewCell
        //Assign a tag to cell to keep track for setting correct image
        cell.tag = indexPath.row
        //Reset thumbnail image to nil for not showing old images when cell is reused
        cell.thumbnailImage.image = nil
        //Set corner radius of the imageView
        cell.thumbnailImage.layer.cornerRadius = 10
        
        //Set the commonNameTextLabel and scientificTextLabel text
        cell.commonNameTextLabel.text = plantsSearchResult.data[indexPath.row].commonName?.sentenceCase() ?? "Unknown"
        cell.scientificNameLabel.text = plantsSearchResult.data[indexPath.row].scientificName.sentenceCase()
        
        //Start animating the activity indicator for the thumbnailImage
        cell.imageActivityViewIndicator.startAnimating()
        
        //If the imageURL field is not empty then download image or look for it in the cache
        if let imageURLString = plantsSearchResult.data[indexPath.row].imageURL{
            currentDownloadImageTask = TrefleAPiClient.downloadImage(imageURL: URL(string: imageURLString)!) { (image, error) in
                if error == nil{
                    if let image = image{
                        //Verify if the tag corresponds to the cell we want to set the image
                        DispatchQueue.main.async {
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
        
        //If there is a current image download task, append it, for canceling if needed
        if let currentDownloadImageTask = currentDownloadImageTask {
            downloadImgURLSessionTasks.append(currentDownloadImageTask)
        }
        
        return cell
    }
    
    //Process the plant selected and trigger segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.Segues.searchToDetails.identifier, sender: nil)
    }
    
}
