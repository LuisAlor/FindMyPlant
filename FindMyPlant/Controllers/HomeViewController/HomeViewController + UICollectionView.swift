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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomPlantsCollectionViewCell.reuseIdentifier, for: indexPath) as! RandomPlantsCollectionViewCell
        
        if let plantImage = plantsData[indexPath.row].imageURL {
            TrefleAPiClient.downloadImage(imageURL: URL(string: plantImage)!) { (data, error) in
                if let data = data {
                    cell.imageView.image = UIImage(data: data)
                }
            }
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "NoImageFound")
        }
        cell.titleLabel.text = plantsData[indexPath.row].scientificName
        Utilities.configureCellStyle(cell)
        
        return cell
    }
    
    
}
