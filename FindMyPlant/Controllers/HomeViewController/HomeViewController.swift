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
    
    var handle: AuthStateDidChangeListenerHandle!
    var userLoggedUponLaunch = true
    var usersRef: CollectionReference!
    
    var db: Firestore!
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDB()
        handle = Auth.auth().addStateDidChangeListener(authListenerHandler(auth:user:))
    }
    
    fileprivate func configureDB() {
        db = Firestore.firestore()
        usersRef = db.collection("users")
    }
    
    deinit {
        //Removes auth listener during deinitialization
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //Check if user is still in db if not remove session by logging out
    fileprivate func isUserSessionValid(user: User?){
        if let currentUserUID = user?.uid {
            usersRef.whereField("uid", isEqualTo: currentUserUID).getDocuments { (querySnapshot, error) in
                if error == nil, querySnapshot?.documents.first == nil {
                    try? Auth.auth().signOut()
                }
            }
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


