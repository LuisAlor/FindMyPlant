//
//  RandomPlantsCollectionViewCell.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 13.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class RandomPlantsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RandomPlantsCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
}
