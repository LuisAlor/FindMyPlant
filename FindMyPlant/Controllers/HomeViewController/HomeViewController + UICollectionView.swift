//
//  HomeViewController + UICollectionView.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 15.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Returns the number of rows for the collectionView obtained from plantsData array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantsData.count
    }
    
    //Generates/Reuses a cell for the collectionView and set all the information for the plant
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Dequee a reusable cell and sets it as type "RandomPlantsCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomPlantsCollectionViewCell.reuseIdentifier, for: indexPath) as! RandomPlantsCollectionViewCell
        
        //Assign a tag to cell to keep track for setting correct image
        cell.tag = indexPath.row
        //Reset thumbnail image to nil for not showing old images when cell is reused
        cell.imageView.image = nil
        
        //Start animating indicator
        cell.imageLoadingIndicator.startAnimating()
        
        //If an image exists (mostly this field is null) then download the image
        if let plantImage = plantsData[indexPath.row].imageURL {
            _ = TrefleAPiClient.downloadImage(imageURL: URL(string: plantImage)!) { (image, error) in
                if let image = image {
                    //Set the current image to the one downloaded
                    DispatchQueue.main.async {
                        //Verify if the tag corresponds to the cell we want to set the image
                        if cell.tag == indexPath.row {
                            cell.imageLoadingIndicator.stopAnimating()
                            //Set the image from the data downloaded or cache
                            cell.imageView.image = image
                        }
                    }
                }
            }
        } else {
            //If no image has been found then stops animating
            cell.imageLoadingIndicator.stopAnimating()
            //Set image to a "No Image Found" one
            cell.imageView.image = #imageLiteral(resourceName: "NoImageFound")
        }
        
        //Set the text label to the scientific name of the plant
        cell.titleLabel.text = plantsData[indexPath.row].scientificName
        //Configure the cells to have shadow and special borders
        Utilities.configureCellStyle(cell)
        
        return cell
    }
    
    //Saves the selected item and performs the segue to DetailsViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.Segues.homeToDetails.identifier, sender: nil)
    }    
    
}
