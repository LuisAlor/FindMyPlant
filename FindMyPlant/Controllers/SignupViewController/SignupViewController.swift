//
//  SignupViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 23.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    //MARK: - setupInterface: Configures all UI Elements after view loaded to memory
    fileprivate func setupInterface(){
        
        //Style buttons
        Utilities.styleFilledButton(registerButton)
        Utilities.styleFilledButton(backButton)
        
        //Set style for textfields and placeholders
        Utilities.styleFormTextField(firstNameTextField, placeholder: "First name")
        Utilities.styleFormTextField(lastNameTextField, placeholder: "Last name")
        Utilities.styleFormTextField(emailTextField, placeholder: "Email")
        Utilities.styleFormTextField(passwordTextField, placeholder: "Password")
        
        //Set textfields delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK:- registerAccount: Verifies fields and sends requeste to Firestore to save user and login
    @IBAction func registerAccount(_ sender: Any) {
        
        var firstName = firstNameTextField.text ?? ""
        var lastName = lastNameTextField.text ?? ""
        var email = emailTextField.text ?? ""
        var password = passwordTextField.text ?? ""
        
        firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if firstName.isEmpty {
            self.presentAlert(Alert.ofType.accCreationFailed, message: "First name field is empty")
        } else if lastName.isEmpty{
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Last name field is empty")
        } else if email.isEmpty{
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Email field is empty")
        }else if !Utilities.isEmailValid(email){
            self.presentAlert(Alert.ofType.accCreationFailed, message: "The email address is badly formatted")
        }else if password.isEmpty{
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Password field is empty")
        }else if !Utilities.isPasswordValid(password){
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Password must be at least 6 characters long and must include one capital letter")
        }else {
            registerButton.isEnabled = false
            activityIndicator.startAnimating()
            Auth.auth().createUser(withEmail: email, password: password, completion: createUserHandler(authResult:error:))
        }
        
    }
    
    //MARK: - goBack: Pops view back to login view
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- createUserHandler: Handles Firebase user creation from completionHandler
    func createUserHandler(authResult: AuthDataResult?, error: Error?){
        if error != nil {
            self.presentAlert(Alert.ofType.accCreationFailed, message: error!.localizedDescription)
            activityIndicator.stopAnimating()
            registerButton.isEnabled = true
        }else{
            _ = FirebaseFMP.shared.db.collection("users").addDocument(data: [
                "uid": authResult!.user.uid,
                "firstName": firstNameTextField.text!,
                "lastName": lastNameTextField.text!,
                "email": emailTextField.text!,
                "favoritePlants": [],
            ], completion: userSaveToDBHandler(error:))
        }
    }
    
    //MARK:- userSaveToDBHandler: If user was correctly saved to Firestore then autologin the user
    func userSaveToDBHandler(error: Error?) {
        if error != nil {
            //Present custom alert if something went wrong while saving user
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Something went wrong while saving data!")
            activityIndicator.stopAnimating()
            registerButton.isEnabled = true

        } else{
            //Sign in automatically the user
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: signinHandler(result:error:))
        }
    }
    
    //MARK: - signinHandler: Handles user signin and verifies in Firebase servers.
     func signinHandler(result: AuthDataResult?, error: Error?){
        if error != nil {
            //If sign in wasn't successful show custom error to user
            self.presentAlert(Alert.ofType.loginFailed, message: error!.localizedDescription)
            activityIndicator.stopAnimating()
            registerButton.isEnabled = true
        } else {
            dismiss(animated: true, completion: nil)
        }
     }

}

