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
    
    //IBOutlets
    @IBOutlet weak var randomPlantsCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dataLoadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIButton!
    
    //Properties
    //Auth State Listener Handle
    var handle: AuthStateDidChangeListenerHandle!
    //Flag for checking user session upon launch
    var userLoggedUponLaunch = true
    //Array of plants data
    var plantsData: [PlantInfo] = []
    //Selected index from collection view
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Firebase Listener Feature
        setupFireBaseFeatures()
        //Setup collection view delegate and datasource
        setupCollectionViews()
        //Initialize our collectionView Refresh control and addTarget
        setupRefreshControl()
        //Download APIKey and Plants Data
        downloadAndSetData()
        //Add segmentedControl target function
        segmentedControl.addTarget(self, action: #selector(didIndexChanged), for: .valueChanged)
    }
    
    //Prepares the data of the plant who is going to be previewed in the DetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToDetailsSegue"{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.plantSelectedData = plantsData[selectedIndex]
        }
    }
    
    //MARK: - deinit: Removes auth listener during deinitialization
    deinit {
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //MARK: - retrieveTrefleAPIKey: Get Trefle APIKey from Firestore server for security purposes
    func retrieveTrefleAPIKey(completionHanlder: @escaping (String, Error?) -> Void){
        FirebaseFMP.shared.applicationKeysRef.document("TrefleAPI").getDocument { (document, error) in
            if error == nil, let document = document {
                let apiKey = document.data()?["apiKey"] as! String
                DispatchQueue.main.async {
                    completionHanlder(apiKey, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHanlder("", nil)
                }
            }
        }
    }
    
    //MARK: - retrieveTrefleAPIKeyHandler: Handles the apiKey result from Firestore servers and saves it to our FirebaseFMP singleton
    func retrieveTrefleAPIKeyHandler(apiKey: String, error: Error?){
        if let error = error {
            presentAlert(Alert.ofType.failedToSetDataToServer, message: error.localizedDescription)
        } else {
            if !apiKey.isEmpty{
                FirebaseFMP.shared.TrefleAPIKey = apiKey
                //After saving our APIKey now call to get data from Trefle
                getAllPlantsInfo()
            }
        }
    }
    
    //MARK: - downloadAndSetData: Downloads API Key and Plants information
    fileprivate func downloadAndSetData() {
        //Start animating the dataLoadingIndicatorView
        dataLoadingIndicatorView.startAnimating()
        //Retrieve the TrefleApi Key and then get plants info
        retrieveTrefleAPIKey(completionHanlder: retrieveTrefleAPIKeyHandler(apiKey:error:))
      }
    
    //MARK: - setupFireBaseFeatures: Configures Authentication Listener Feature
    fileprivate func setupFireBaseFeatures() {
        handle = Auth.auth().addStateDidChangeListener(authListenerHandler(auth:user:))
    }
    
    //MARK: - setupRefreshControl: Configures refresh control for collection view and adds a target
    fileprivate func setupRefreshControl() {
        randomPlantsCollectionView.refreshControl = UIRefreshControl()
        randomPlantsCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    //MARK: - setupCollectionViews: Configures the CollectionFlowLayout, sets delegation and datasource for the CollectionView
    fileprivate func setupCollectionViews() {
        randomPlantsCollectionView.delegate = self
        randomPlantsCollectionView.dataSource = self
        setCollectionFlowLayout(randomPlantsCollectionView, items: 2, scrollDirectionType: .vertical)
    }
    
    //MARK: - handleTotalPlantsPages: Gets new data from Trefle and populates it
    @objc private func pullToRefresh() {
        //Get new data from Trefle
        getAllPlantsInfo()
        //Remove all from cache
        TrefleAPiClient.imageCache.removeAllObjects()
    }
    
    //MARK: - handleTotalPlantsPages: Selects which request should be processed Random or Edible Plants
    @objc private func didIndexChanged(){
        //Start animating the dataLoadingIndicatorView
        dataLoadingIndicatorView.startAnimating()
        //Remove all old data
        plantsData.removeAll()
        //Remove old images from cache
        TrefleAPiClient.imageCache.removeAllObjects()
        //Get new data from Trefle server
        getAllPlantsInfo()

    }
    
    //MARK: - isUserSessionValid: Checks if user is still in db if not removes session by logging out
    fileprivate func isUserSessionValid(user: User?){
        if let currentUserUID = user?.uid {
            FirebaseFMP.shared.usersRef.whereField("uid", isEqualTo: currentUserUID).getDocuments(completion: handleUserQuery(querySnapshot:error:))
        }
    }
    
    //MARK: - handleTotalPlantsPages: Main logic to select which query should be sent according to the segmented control selection
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
    
    //MARK: - handleTotalPlantsPages: Gets total of pages from the request and generates a random page plant new query
    func handleTotalPlantsPages(totalPages: Int, error: Error?){
        if error == nil, totalPages != 0 {
            if segmentedControl.selectedSegmentIndex == 0{
                //Get all type of random plants
                TrefleAPiClient.getRandomPlants(fromPage: Utilities.generateRandomNumber(maxRange: totalPages), completionHandler: handleGetRandomPlants(plantInfo:error:))
            } else{
                //Get random edible plants only
                TrefleAPiClient.getRandomEdiblePlants(fromPage: Utilities.generateRandomNumber(maxRange: totalPages), completionHandler: handleGetRandomPlants(plantInfo:error:))
            }
        }
    }
    
    //MARK: - handleGetRandomPlants: Handles the data from random plants and populates collection view
    func handleGetRandomPlants(plantInfo: [PlantInfo]?, error: Error?){
        if error == nil {
            if let plantInfo = plantInfo {
                //Save the plants data to our property "plantsData"
                self.plantsData = plantInfo
                
                //Stop animating the collection view "refreshControl"
                randomPlantsCollectionView.refreshControl?.endRefreshing()
                //Stop animating the "dataLoadingIndicatorView"
                dataLoadingIndicatorView.stopAnimating()
                
                //Reload for showing new data in collectiong view
                randomPlantsCollectionView.reloadData()
                //Reveal the collection view when all data is now ready
                randomPlantsCollectionView.isHidden = false
            }
        }
    }

    //MARK: - setCollectionFlowLayout: Configures the CollectionView Flow layout for items to fit accoarding to its content.
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
    
    //MARK: - handleUserQuery: Handles user query for UID, if no match then user does not exist anymore and must break the session.
    func handleUserQuery (querySnapshot: QuerySnapshot?, error: Error?){
        if error == nil, querySnapshot?.documents.first == nil {
            try? Auth.auth().signOut()
        }
    }
    
    //MARK: - authListenerHandler: Handles addStateDidChangeListener and manages view modal presentation or dismissal
    func authListenerHandler(auth: Auth, user: User?){
        
        if let user = user {
            //Verify if user session is valid (If user is not deleted or blocked)
            isUserSessionValid(user: user)
            //Save user to our singleton for later use
            FirebaseFMP.shared.saveUser(user)
            //Check if user was logged in upon launch if not dismiss after successful login
            if !userLoggedUponLaunch {
                dismiss(animated: true, completion: nil)
            }
        } else {
            //Show login screen
            performSegue(withIdentifier: "modalLoginSegue", sender: nil)
            //User was not logged when app launched, set as false
            userLoggedUponLaunch = false
        }
    }
    
    //MARK: - logout: Log outs the user from the current session
    @IBAction func logout(_ sender: Any) {
        //We do not care about error handling for user during logout.
        try? Auth.auth().signOut()
   }
    
    //MARK: - refreshData: Reloads the data to new random or edible plants according to the segmented control selection
    @IBAction func refreshData(_ sender: Any) {
        //Start animating dataLoadingIndicatorView
        dataLoadingIndicatorView.startAnimating()
        //Remove all from cache as we don't need it
        TrefleAPiClient.imageCache.removeAllObjects()
        //Hide collectionView while data is not ready
        randomPlantsCollectionView.isHidden = true
        //Get new data from Trefle
        getAllPlantsInfo()
    }
    
    
}


