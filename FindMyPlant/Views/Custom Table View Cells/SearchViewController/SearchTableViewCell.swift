//
//  SearchTableViewCell.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 19.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchTableViewCell"
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var commonNameTextLabel: UILabel!

}
