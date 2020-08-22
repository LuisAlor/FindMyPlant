//
//  HomeViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 19.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var randomPlantsCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dataLoadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle!
    var userLoggedUponLaunch = true
        
    var plantsData: [PlantInfo] = []
    var didPlantDataChanged = false
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFireBaseFeatures()
        setupCollectionViews()
        setupRefreshControl()
        dataLoadingIndicatorView.startAnimating() // Refactor
        getAllPlantsInfo()
        
        segmentedControl.addTarget(self, action: #selector(didIndexChanged), for: .valueChanged)
    }
    
    //Prepares the data of the plant who is going to be previewed in the DetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToDetailsSegue"{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.plantSelectedData = plantsData[selectedIndex]
        }
    }
    
    deinit {
        //Removes auth listener during deinitialization
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    fileprivate func setupFireBaseFeatures() {
        handle = Auth.auth().addStateDidChangeListener(authListenerHandler(auth:user:))
    }
    
    fileprivate func setupRefreshControl() {
        randomPlantsCollectionView.refreshControl = UIRefreshControl()
        randomPlantsCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        getAllPlantsInfo()
        TrefleAPiClient.imageCache.removeAllObjects()
    }
    
    @objc private func didIndexChanged(){
        dataLoadingIndicatorView.startAnimating()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //Generate random page for all type of plants
            plantsData.removeAll()
            TrefleAPiClient.imageCache.removeAllObjects()
            randomPlantsCollectionView.reloadData()
            getAllPlantsInfo()

        case 1:
            //Generates random page for all edible plants only
            plantsData.removeAll()
            TrefleAPiClient.imageCache.removeAllObjects()
            randomPlantsCollectionView.reloadData()
            getAllPlantsInfo()

        default:
            return
        }
    }
    
    //Checks if user is still in db if not removes session by logging out
    fileprivate func isUserSessionValid(user: User?){
        if let currentUserUID = user?.uid {
            FirebaseFMP.shared.usersRef.whereField("uid", isEqualTo: currentUserUID).getDocuments(completion: handleUserQuery(querySnapshot:error:))
        }
    }
   
    //Configures the CollectionFlowLayout, sets delegation and datasource for the CollectionView
    fileprivate func setupCollectionViews() {
        randomPlantsCollectionView.delegate = self
        randomPlantsCollectionView.dataSource = self
        setCollectionFlowLayout(randomPlantsCollectionView, items: 2, scrollDirectionType: .vertical)
    }
    
    fileprivate func getAllPlantsInfo() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            TrefleAPiClient.getTotalPlantsPages(by: .all, completionHandler: handleTotalPlantsPages(totalPages:error:))
        case 1:
            TrefleAPiClient.getTotalPlantsPages(by: .onlyEdible, completionHandler: handleTotalPlantsPages(totalPages:error:))
        default:
            return
        }
    }
    
    func handleTotalPlantsPages(totalPages: Int, error: Error?){
        if error == nil, totalPages != 0 {
            if segmentedControl.selectedSegmentIndex == 0{
                TrefleAPiClient.getRandomPlants(fromPage: Utilities.generateRandomNumber(maxRange: totalPages), completionHandler: handleGetRandomPlants(plantInfo:error:))
            } else{
                TrefleAPiClient.getRandomEdiblePlants(fromPage: Utilities.generateRandomNumber(maxRange: totalPages), completionHandler: handleGetRandomPlants(plantInfo:error:))
            }
        }
    }
    
    func handleGetRandomPlants(plantInfo: [PlantInfo]?, error: Error?){
        if error == nil {
            if let plantInfo = plantInfo {
                plantsData.removeAll()
                self.plantsData = plantInfo
                randomPlantsCollectionView.refreshControl?.endRefreshing()
                dataLoadingIndicatorView.stopAnimating()
                didPlantDataChanged = true
                randomPlantsCollectionView.reloadData()
            }
        }
    }

    //Configures the CollectionView Flow layout for our items to fit accoarding to its content.
    func setCollectionFlowLayout(_ collectionView: UICollectionView, items: CGFloat, scrollDirectionType: UICollectionView.ScrollDirection) {

        let space: CGFloat = 8
        let dimensions = (view.frame.size.width - ((items + 1) * space)) / items

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = space
        layout.itemSize = CGSize(width: dimensions, height: dimensions)
        layout.scrollDirection = scrollDirectionType

        collectionView.collectionViewLayout = layout
    }
    
    //Handles user query for UID, if something is not matched then user does not exist anymore and must break the session.
    func handleUserQuery (querySnapshot: QuerySnapshot?, error: Error?){
        if error == nil, querySnapshot?.documents.first == nil {
            try? Auth.auth().signOut()
        }
    }
    
    //Handles addStateDidChangeListener and sets a new Root View as Key
    func authListenerHandler(auth: Auth, user: User?){
        if let user = user {
            
            isUserSessionValid(user: user)
            FirebaseFMP.shared.saveUser(user)
            //FirebaseFMP.shared.user = user
            
            //Check if user was logged in upon launch if not dismiss after successful login
            if !userLoggedUponLaunch {
                dismiss(animated: true, completion: nil)
            }
        } else {
            performSegue(withIdentifier: "modalLoginSegue", sender: nil)
            //User was not logged when app launched, set as false
            userLoggedUponLaunch = false
        }

    }
    
    @IBAction func logout(_ sender: Any) {
        //We do not care about error handling for user during logout.
        try? Auth.auth().signOut()
   }
    
}


