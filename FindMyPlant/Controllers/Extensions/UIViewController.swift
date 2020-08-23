//
//  UIViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 23.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension UIViewController{
    
    //MARK: - getUserFavoritePlants: Returns an array of ids from user favorite plants
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
    
    func isFavorite(favoritePlants: Array<Int>, id: Int) -> Bool {
        if favoritePlants.contains(id){
            return true
        }else {
            return false
        }
        
    }
    
    func selectFavButtonImage(status: Bool) -> UIImage {
        if status {
            return Constants.SystemIcons.favoriteIconFill.image
        } else {
            return Constants.SystemIcons.favoriteIcon.image
        }
    }
    
    //MARK: - showAlert: Create an alert
    func presentAlert(_ type: Alert.ofType, message: String){
        let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController: UITextFieldDelegate{
    //MARK: - textFieldShouldReturn: Dismiss keyboard if return was pressed
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
