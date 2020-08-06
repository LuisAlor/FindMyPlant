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

    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener(authListenerHandler(auth:user:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        //Removes auth listener during deinitialization
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //Handles addStateDidChangeListener and sets a new Root View as Key
    func authListenerHandler(auth: Auth, user: User?){
        if user != nil {
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


