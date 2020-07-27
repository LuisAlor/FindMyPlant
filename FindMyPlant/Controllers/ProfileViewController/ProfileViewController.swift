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
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.loginController.identifier) as! LoginViewController
            if let window = view.window{
                window.rootViewController = loginVC
                UIView.transition(with: window,
                                  duration: 0.5,
                                     options: [.transitionFlipFromLeft],
                                     animations: nil,
                                     completion: nil)
            }
        } catch {
            print("unable to sign out: \(error)")
        }
    }

}
