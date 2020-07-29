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
    
    //IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        
        var email = emailTextField.text ?? ""
        var password = passwordTextField.text ?? ""

        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email.isEmpty {
            self.presentAlert(Alert.ofType.loginFailed, message: "The email field is empty")
        }else if !Utilities.isEmailValid(email){
            self.presentAlert(Alert.ofType.loginFailed, message: "The email address is badly formatted")
        }
        else if password.isEmpty {
            self.presentAlert(Alert.ofType.loginFailed, message: "The password field is empty")
        }else {
            //Sign in the user
            activityIndicator.startAnimating()
            loginButton.isEnabled = false
            Auth.auth().signIn(withEmail: email, password: password, completion: signinHandler(result:error:))
        }
    }
    
    //Handles user signin and verifies in Firebase servers.
    func signinHandler(result: AuthDataResult?, error: Error?){
        if error != nil {
            self.presentAlert(Alert.ofType.loginFailed, message: error!.localizedDescription)
        }
        activityIndicator.stopAnimating()
        loginButton.isEnabled = true
    }

}
