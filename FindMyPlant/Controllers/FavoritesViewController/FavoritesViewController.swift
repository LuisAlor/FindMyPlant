//
//  FavoritesViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 22.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FavoritesViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var loadingActivityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    //Properties
    var userDocumentID: String!
    var favoritePlantsInfo: [PlantInfo] = []
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup TableView
        setupTableView()
        //Get ready loading interface and data
        setupInterfaceAndData()
    }

    //MARK: - setupTableView: Setups all needed for out tableView upon viewDidLoad
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.isHidden = true
    }
    
    //MARK: - setupInterfaceAndData: Setups our interface objects and downloads user's fav list
    fileprivate func setupInterfaceAndData() {
        statusLabel.isHidden = true
        loadingActivityViewIndicator.startAnimating()
        getUserFavoritePlants(completionHandler: getUserFavoritePlantsHandler(documentID:plantsId:error:))
    }
    
    //MARK: - prepare: Gets data ready to pass to DetailsVC when performing the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.favoritesToDetails.identifier{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.plantSelectedData = favoritePlantsInfo[selectedIndex]
        }
    }
    
    //MARK: - pullToRefresh: Refreshes the data if pulled down
    @objc private func pullToRefresh() {
        getUserFavoritePlants(completionHandler: getUserFavoritePlantsHandler(documentID:plantsId:error:))
    }
    
    //MARK: - getUserFavoritePlantsHandler: Handles the downloaded favorite list from user
    func getUserFavoritePlantsHandler(documentID: String, plantsId: [Int], error: Error?){
        if let error = error {
            //Show alert to user if couldn't retrieve fav list
            presentAlert(Alert.ofType.failedToSetDataToServer, message: error.localizedDescription)
        } else {
            if plantsId.count == 0 {
                
                //Hide tableView since no data was foun and reveal instead the status label
                tableView.isHidden = true
                statusLabel.isHidden = false
                
                //Set statusLabel to "You have no favorite plants yet!"
                statusLabel.text = Constants.LabelTextStatus.noFavorites.message
                
                //Stop animating the indicator view and the refreshControl
                self.loadingActivityViewIndicator.stopAnimating()
                self.tableView.refreshControl?.endRefreshing()
            }
            //Sets userDocumentID property to the user's unique documentID
            userDocumentID = documentID
            //Gets all the plants by ID that are stored in the user's fav list
            TrefleAPiClient.getPlantsByID(plantsId, completionHandler: getPlantsByIDHandler(plantsInfo:error:))
        }
    }
    
    //MARK: - getPlantsByIDHandler: Handles the data from every plant gotten by ID from Trefle servers saved in the user's fav list
    func getPlantsByIDHandler(plantsInfo: [PlantInfo], error: Error?){
        
        //Saves the data from server into favoritePlantsInfo property
        favoritePlantsInfo = plantsInfo
        //Reload the tableView Data
        tableView.reloadData()
        
        //Hide the status label and reveal the tableView
        statusLabel.isHidden = true
        tableView.isHidden = false
        
        loadingActivityViewIndicator.stopAnimating()
        tableView.refreshControl?.endRefreshing()
    }
    
    //MARK: - unsetFavoritePlant: Removes from server the plant that was in user's favorite list
    func unsetFavoritePlant(forRow: Int){
        FirebaseFMP.shared.usersRef.document(userDocumentID).updateData([
            "favoritePlants": FieldValue.arrayRemove([favoritePlantsInfo[forRow].id])
        ], completion: unsetFavoritePlantHandler(error:))
    }
    
    //MARK: - unsetFavoritePlantHandler: Handles error alert in case there was an error while trying to unset from server
    func unsetFavoritePlantHandler(error:Error?){
        if let error = error {
            presentAlert(Alert.ofType.failedToSetDataToServer, message: error.localizedDescription)
        }
    }
    
    //MARK: - refreshFavorites: Gets new data from Trefle server, updates the tableView and sets interface
    @IBAction func refreshFavorites(_ sender: Any) {
        
        //Hide the status label and tableView
        statusLabel.isHidden = true
        tableView.isHidden = true
        
        //Start animating while getting the new data
        loadingActivityViewIndicator.startAnimating()
        
        //Get user favorite plants
        getUserFavoritePlants(completionHandler: getUserFavoritePlantsHandler(documentID:plantsId:error:))
    }
    

}
