//
//  FavoritesTableViewCell.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 19.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
   
    static let reuseIdentifier = "FavoritesTableViewCell"
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var commonNameTextLabel: UILabel!
    @IBOutlet weak var scientificTextLabel: UILabel!
    @IBOutlet weak var imageActivityViewIndicator: UIActivityIndicatorView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    

}
