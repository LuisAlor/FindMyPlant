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

    @IBOutlet weak var loadingActivityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var userDocumentID: String!
    var favoritePlantsInfo: [PlantInfo] = []
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

        
        tableView.delegate = self
        tableView.dataSource = self
                
        loadingActivityViewIndicator.startAnimating()
        tableView.isHidden = true
        getUserFavoritePlants(completionHandler: getUserFavoritePlantsHandler(documentID:plantsId:error:))

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.favoritesToDetails.identifier{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.plantSelectedData = favoritePlantsInfo[selectedIndex]
        }
    }
    
    @objc private func pullToRefresh() {
        getUserFavoritePlants(completionHandler: getUserFavoritePlantsHandler(documentID:plantsId:error:))
    }
    
    func getUserFavoritePlantsHandler(documentID: String, plantsId: [Int], error: Error?){
        if let error = error {
            print(error)
        } else {
            self.userDocumentID = documentID
            TrefleAPiClient.getPlantsByID(plantsId, completionHandler: getPlantsByIDHandler(plantsInfo:error:))
        }
    }
    
    func getPlantsByIDHandler(plantsInfo: [PlantInfo], error: Error?){
        self.favoritePlantsInfo = plantsInfo
        self.tableView.reloadData()
        self.tableView.isHidden = false
        self.loadingActivityViewIndicator.stopAnimating()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func unsetFavoritePlant(forRow: Int){
        FirebaseFMP.shared.usersRef.document(userDocumentID).updateData([
            "favoritePlants": FieldValue.arrayRemove([favoritePlantsInfo[forRow].id])
        ], completion: unsetFavoritePlantHandler(error:))
    }
    
    func unsetFavoritePlantHandler(error:Error?){
        if error != nil {
            print(error!)
        }
    }

}
