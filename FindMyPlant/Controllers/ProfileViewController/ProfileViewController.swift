//
//  ProfileViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 22.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        //We do not care about error handling for user during logout.
        try? Auth.auth().signOut()
        //Pop back to home and then dismiss the controller for always return to the home screen and not to profile.
        self.navigationController?.popViewController(animated: false)
        dismiss(animated: true, completion: nil)
    }

}
