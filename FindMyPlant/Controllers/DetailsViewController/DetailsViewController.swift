//
//  DetailsViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class DetailsViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var likeToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var yearRegisteredLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bibliographyLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var genusLabel: UILabel!
    @IBOutlet weak var loadingActivityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    //Properties
    var plantSelectedData: PlantInfo!
    var userDocumentID: String!
    var isPlantFavorite: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set selected objects from interface to hidden
        setInterfaceItemsVisible(false)
        //Set Loading Items to visible
        setLoadingItemsVisible(true)
        //Get user favorite list to verify if the plant selected is there and update the favorite image
        getUserFavoritePlants(completionHandler: getUserFavoritePlantsHandler(documentID:plantsId:error:))
    }
    
    //MARK: - setInterfaceItemsVisible: Sets visible or hidden the necessary items for the interface
    func setInterfaceItemsVisible(_ itemsVisible: Bool) {
        if itemsVisible {
            rootStackView.isHidden = false
            likeToolbar.isHidden = false
            imageView.isHidden = false
        } else {
            rootStackView.isHidden = true
            likeToolbar.isHidden = true
            imageView.isHidden = true
        }
    }
    
    //MARK: - setLoadingItemsVisible: Sets visible or hidden the loading items for the interface
    func setLoadingItemsVisible(_ itemsVisible: Bool){
        if itemsVisible{
            loadingActivityViewIndicator.startAnimating()
            loadingLabel.isHidden = false
        } else {
            loadingActivityViewIndicator.stopAnimating()
            loadingLabel.isHidden = true
        }
    }
    
    //MARK: - setFavoritePlant: Sends request to server to add selected plant to the user's fav list
    func setFavoritePlant(){
        likeButton.image = Constants.SystemIcons.favoriteIconFill.image
        isPlantFavorite = true
        FirebaseFMP.shared.usersRef.document(userDocumentID).updateData([
            "favoritePlants": FieldValue.arrayUnion([plantSelectedData.id])
            ], completion: setFavoritePlantHandler(error:))
    }
    
    //MARK: - unsetFavoritePlant: Sends request to server to remove selected plant from the user's fav list
    func unsetFavoritePlant(){
        likeButton.image = Constants.SystemIcons.favoriteIcon.image
        isPlantFavorite = false
        FirebaseFMP.shared.usersRef.document(userDocumentID).updateData([
        "favoritePlants": FieldValue.arrayRemove([plantSelectedData.id])
        ], completion: unsetFavoritePlantHandler(error:))
    }
    
    //MARK: - getUserFavoritePlantsHandler: Handles the data from user's fav list and documentID
    func getUserFavoritePlantsHandler(documentID: String, plantsId: [Int], error: Error?){
        if let error = error{
            //Present custom alert if the request failed to retreive user's fav list
            presentAlert(Alert.ofType.failedToRetrieveDataFromServer, message: error.localizedDescription)
        } else {
            //Set the document id for setting/unsetting favorite plant
            self.userDocumentID = documentID
            //Save if the selected plant is currently favorite
            self.isPlantFavorite = isFavorite(favoritePlants: plantsId, id: self.plantSelectedData.id)
            // Verify the image is field is not nil and download of get from cache
            if let imageStringURL = plantSelectedData.imageURL{
                _ = TrefleAPiClient.downloadImage(imageURL: URL(string: imageStringURL)!, completionHandler: downloadImageHandler(image:error:))
            } else {
                self.imageView.image = #imageLiteral(resourceName: "NoImageFound")
                //Populate all the details needed for the selected plant
                setupPlantDetails()
                setInterfaceItemsVisible(true)
                setLoadingItemsVisible(false)
            }
        }
    }
    
    //MARK: - setupPlantDetails: Sets the plant's corresponding data to all our objects.
    fileprivate func setupPlantDetails() {
        //Set the likeButton image to the corresponding one
        likeButton.image = selectFavButtonImage(status: isPlantFavorite)
        
        //Set commonName text to the UILabel or Unknown if nil, also applies "Sentence case" to the name
        commonNameLabel.text = plantSelectedData.commonName?.sentenceCase() ?? "Unknown"
        //Set scientificName text to the UILabel
        scientificNameLabel.text = plantSelectedData.scientificName
        
        //If year is not nil then convert it to string type in order to set it to the UILabel
        if let year = plantSelectedData.yearRegistered {
            yearRegisteredLabel.text = String(year)
        }
        //Set author text to the UILabel or Unknown if nil
        authorLabel.text = plantSelectedData.author ?? "Unknown"
        //Set bibliography text to the UILabel or Unknown if nil
        bibliographyLabel.text = plantSelectedData.bibliography ?? "Unknown"
        //Set family text to the UILabel or Unknown if nil
        familyLabel.text = plantSelectedData.family ?? "Unknown"
        //Set genus text to the UILabel
        genusLabel.text = plantSelectedData.genus
    }
    
    //MARK: - setFavoritePlantHandler: Handles error alert in case there was an error while trying to set from server
    func setFavoritePlantHandler(error:Error?){
        if let error = error {
            presentAlert(Alert.ofType.failedToSetDataToServer, message: error.localizedDescription)
        }
    }
    
    //MARK: - unsetFavoritePlantHandler: Handles error alert in case there was an error while trying to unset from server
    func unsetFavoritePlantHandler(error:Error?){
        if let error = error {
            presentAlert(Alert.ofType.failedToSetDataToServer, message: error.localizedDescription)
        }
    }
    
    //MARK: - downloadImageHandler: Handles image download or cache retrieval
    func downloadImageHandler(image: UIImage?, error: Error?){
        if error == nil {
            if let image = image {
                imageView.image = image
                //Populate all the details needed for the selected plant
                setupPlantDetails()
                setInterfaceItemsVisible(true)
                setLoadingItemsVisible(false)
            }
        }
    }
    
    //MARK: - favoritePlant: Sets or Unsets selected plant to user's favorite list
    @IBAction func favoritePlant(_ sender: Any) {

        if isPlantFavorite {
            unsetFavoritePlant()
        } else {
            setFavoritePlant()
        }
    }
    

}
