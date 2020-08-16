//
//  HomeViewController + UICollectionView.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 15.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Dequees a reusable cell and sets it as type "RandomPlantsCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomPlantsCollectionViewCell.reuseIdentifier, for: indexPath) as! RandomPlantsCollectionViewCell
        
        //Removes any previous image making it nil when user swipes down in order to not see previous plus loading indicator
        if didPlantDataChanged {
            cell.imageView.image = nil
        }
        
        //Starts animating indicator
        cell.imageLoadingIndicator.startAnimating()
        
        //If an image exists (mostly this field is null) then download the image
        if let plantImage = plantsData[indexPath.row].imageURL {
            TrefleAPiClient.downloadImage(imageURL: URL(string: plantImage)!) { (data, error) in
                if let data = data {
                    //Stops animating
                    cell.imageLoadingIndicator.stopAnimating()
                    //Sets the current image to the one downloaded
                    cell.imageView.image = UIImage(data: data)
                }
            }
        } else {
            //If no image has been found then stops animating
            cell.imageLoadingIndicator.stopAnimating()
            //Sets image to a "No Image Found" one
            cell.imageView.image = #imageLiteral(resourceName: "NoImageFound")
        }
        
        //Sets the text label to the scientific name of the plant
        cell.titleLabel.text = plantsData[indexPath.row].scientificName
        //Configures the cells to have shadow and special borders
        Utilities.configureCellStyle(cell)
        
        return cell
    }
    
    
}
