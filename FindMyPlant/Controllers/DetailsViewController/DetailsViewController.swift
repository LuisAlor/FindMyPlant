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
    var favoritePlants = [Int]()
    var userDocumentID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageStringURL = plantSelectedData.imageURL{
          _ = TrefleAPiClient.downloadImage(imageURL: URL(string: imageStringURL)!, completionHandler: downloadImageHandler(image:error:))
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
            
        //Download from DB the user fav plants
        getUserFavoritePlants(completionHandler: getUserFavoritePlantsHandler(documentID:plantsId:error:))
        
        if isPlantFavorited(){
            likeButton.image = UIImage(systemName: "heart.fill")
        } else {
            likeButton.image = UIImage(systemName: "heart")
        }
        
    }
    
    func setFavoritePlant(){
        FirebaseFMP.shared.usersRef.document(userDocumentID).updateData([
            "favoritePlants": FieldValue.arrayUnion([plantSelectedData.id])
            ], completion: setFavoritePlantHandler(error:))
    }
    
    func unsetFavoritePlant(){
        FirebaseFMP.shared.usersRef.document(userDocumentID).updateData([
        "favoritePlants": FieldValue.arrayRemove([plantSelectedData.id])
        ], completion: unsetFavoritePlantHandler(error:))
    }
    
    func setFavoritePlantHandler(error:Error?){
        if error != nil {
            print(error!)
        }
    }
    
    func unsetFavoritePlantHandler(error:Error?){
        if error != nil {
            print(error!)
        }
    }
    
    //Handle error if favorited plant was not saved successfully to DB
    func saveFavoritePlantsToDBHandler(error: Error?){
        if error != nil{
            print(error!)
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
    
    func getUserFavoritePlants(completionHandler: @escaping (String, [Int] , Error?)-> Void){

        FirebaseFMP.shared.usersRef.whereField("uid", isEqualTo: FirebaseFMP.shared.user.uid).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot, error == nil{
                if let userDocument = querySnapshot.documents.first{
                    let documentID = userDocument.documentID
                    let favPlantsID = userDocument.data()["favoritePlants"] as! Array<Int>
                    DispatchQueue.main.async {
                        completionHandler(documentID, favPlantsID , nil)
                    }
                }
            } else{
                DispatchQueue.main.async {
                    completionHandler("", [], error)
                }
            }
        }
    }
    
    func getUserFavoritePlantsHandler(documentID: String, plantsId: [Int], error: Error?){
        if let error = error{
            print(error)
        } else {
            self.favoritePlants = plantsId
            self.userDocumentID = documentID
        }
    }
    
    @IBAction func favoritePlant(_ sender: Any) {
        if isPlantFavorited() {
            unsetFavoritePlant()
        } else {
            setFavoritePlant()
        }
    }
    

}
