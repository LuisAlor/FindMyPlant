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
    
    var handle: AuthStateDidChangeListenerHandle!
    var userLoggedUponLaunch = true
    var usersRef: CollectionReference!
    
    var db: Firestore!
    var ref: DocumentReference? = nil
    
    var plantsData: [PlantInfo] = []
    var didPullDownToRefresh = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFireBaseFeatures()
        setupCollectionViews()
        setupRefreshControl()
        getPlantsTotalPages()
    }
    
    deinit {
          //Removes auth listener during deinitialization
          Auth.auth().removeStateDidChangeListener(handle)
    }
    
    fileprivate func configureDB() {
        db = Firestore.firestore()
        usersRef = db.collection("users")
    }
    
    fileprivate func setupFireBaseFeatures() {
        configureDB()
        handle = Auth.auth().addStateDidChangeListener(authListenerHandler(auth:user:))
    }
    
    fileprivate func setupRefreshControl() {
        randomPlantsCollectionView.refreshControl = UIRefreshControl()
        randomPlantsCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        TrefleAPiClient.getTotalPlantsPages(completionHandler: handleTotalPlantsPages(totalPages:error:))
           didPullDownToRefresh = true
    }
    
    //Checks if user is still in db if not removes session by logging out
    fileprivate func isUserSessionValid(user: User?){
        if let currentUserUID = user?.uid {
            usersRef.whereField("uid", isEqualTo: currentUserUID).getDocuments(completion: handleUserQuery(querySnapshot:error:))
        }
    }
   
    //Configures the CollectionFlowLayout, sets delegation and datasource for the CollectionViews and starts animating it indicator view
    fileprivate func setupCollectionViews() {
        randomPlantsCollectionView.delegate = self
        randomPlantsCollectionView.dataSource = self
        setCollectionFlowLayout(randomPlantsCollectionView, items: 2, scrollDirectionType: .vertical)
        dataLoadingIndicatorView.startAnimating()
    }
    
    fileprivate func getPlantsTotalPages() {
        TrefleAPiClient.getTotalPlantsPages(completionHandler: handleTotalPlantsPages(totalPages:error:))
    }
    
    func handleTotalPlantsPages(totalPages: Int, error: Error?){
        if error == nil, totalPages != 0 {
            TrefleAPiClient.getRandomPlants(fromPage: Utilities.generateRandomNumber(maxRange: totalPages), completionHandler: handleGetRandomPlants(plantInfo:error:))
        }
    }
    
    func handleGetRandomPlants(plantInfo: [PlantInfo]?, error: Error?){
        if error == nil {
            if let plantInfo = plantInfo {
                self.plantsData = plantInfo
                if didPullDownToRefresh {
                    randomPlantsCollectionView.refreshControl?.endRefreshing()
                } else {
                    dataLoadingIndicatorView.stopAnimating()
                }
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
        if user != nil {
            
            isUserSessionValid(user: user)
            
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
    
}


