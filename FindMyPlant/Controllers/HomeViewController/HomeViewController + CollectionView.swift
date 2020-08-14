//
//  HomeViewController + CollectionView.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 13.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Sets the number of sections for each collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.headerCollectionView {
            return 6
        }else {
            return 20
        }
    }
    //Format cells for each collection view and populate them with proper data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.randomPlantsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseCellID.homeRandomPlantsCell.identifier, for: indexPath) as! RandomPlantsCollectionViewCell
            cell.imageView.image = #imageLiteral(resourceName: "FindMyPlant-icon")
            cell.titleLabel.text = "Plant"
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 1
         
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseCellID.homeHeaderCell.identifier, for: indexPath) as! HeaderCollectionViewCell
            cell.imageView.image = #imageLiteral(resourceName: "welcome_banner")
            cell.imageView.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
    }
    
    //Selected object from indexPath should be opened with its data in a DetailsViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.headerCollectionView {
            print("Pressed Header")
        }else {
            print("Pressed Random")
        }
    }
    
    
}
