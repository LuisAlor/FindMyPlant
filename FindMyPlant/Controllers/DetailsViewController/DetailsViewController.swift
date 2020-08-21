//
//  DetailsViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var yearRegisteredLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bibliographyLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var genusLabel: UILabel!
    
    var plantSelectedData: PlantInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageStringURL = plantSelectedData.imageURL{
            TrefleAPiClient.downloadImage(imageURL: URL(string: imageStringURL)!, completionHandler: downloadImageHandler(image:error:))
        } else {
            imageView.image = #imageLiteral(resourceName: "NoImageFound")
        }
        commonNameLabel.text = plantSelectedData.commonName?.sentenceCase() ?? "Unknown"
        scientificNameLabel.text = plantSelectedData.scientificName
        if let year = plantSelectedData.yearRegistered {
            yearRegisteredLabel.text = String(year)
        }
        authorLabel.text = plantSelectedData.author ?? "Unknown"
        bibliographyLabel.text = plantSelectedData.bibliography ?? "Unknown"
        familyLabel.text = plantSelectedData.family ?? "Unknown"
        genusLabel.text = plantSelectedData.genus
        
        if isPlantFavorited(){
            likeButton.image = UIImage(systemName: "heart.fill")
        }
        
    }
    
    func downloadImageHandler(image: UIImage?, error: Error?){
        if error == nil {
            if let image = image {
                imageView.image = image
            }
        }
    }
    
    func isPlantFavorited() -> Bool {
        let number = Int.random(in: 0...1)
        let isFavorite = number == 1 ? true : false
        return isFavorite
    }

}
