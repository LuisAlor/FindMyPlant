//
//  LoginViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 22.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //Firestore Properties
    var db: Firestore!
    var ref: DocumentReference? = nil
    var handle:AuthStateDidChangeListenerHandle!
    
    //IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        configureAuth()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //Configures interface upon launch
    fileprivate func setupInterface(){
        //Setup TextField's and Button's Style
        Utilities.styleFormTextField(emailTextField, placeholder: "Email")
        Utilities.styleFormTextField(passwordTextField, placeholder: "Password")
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledButton(signupButton)
        
        //Set TextFields' delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //Configures Authentication
    func configureAuth(){
        handle = Auth.auth().addStateDidChangeListener { (auth, activeUser) in
            if let _ = activeUser {
            
            }
        }
    }
    
    //Sets sign in status.
    func signedInStatus(isSignedIn:Bool){
        if isSignedIn{
            configureDB()
        }
    }
    
    //Configures FireStore DB.
    func configureDB(){
        db = Firestore.firestore()
    }
    
    //Logins user with credentials (verifies fields are filled and correct).
    @IBAction func login(_ sender: Any) {
                
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign in the user
        Auth.auth().signIn(withEmail: email, password: password, completion: signinHandler(result:error:))
    }
    
    //Handles user signin and verifies in Firebase servers.
    func signinHandler(result: AuthDataResult?, error: Error?){
        if error != nil {
            self.presentAlert(Alert.ofType.loginFailed, message: error!.localizedDescription)
        }else{
            performSegue(withIdentifier: Constants.StoryboardSegueID.loginToHome.identifier, sender: nil)
        }
    }

}
