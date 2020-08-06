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

class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var db: Firestore!
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    fileprivate func setupInterface(){
        
        Utilities.styleFilledButton(registerButton)
        
        Utilities.styleFormTextField(firstNameTextField, placeholder: "First name")
        Utilities.styleFormTextField(lastNameTextField, placeholder: "Last name")
        Utilities.styleFormTextField(emailTextField, placeholder: "Email")
        Utilities.styleFormTextField(passwordTextField, placeholder: "Password")
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
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
            cancelButton.isEnabled = false
            activityIndicator.startAnimating()
            Auth.auth().createUser(withEmail: email, password: password, completion: createUserHandler(authResult:error:))
        }
        
    }
    
    //Handle Firebase user creation from completionHandler
    func createUserHandler(authResult: AuthDataResult?, error: Error?){
        if error != nil {
            self.presentAlert(Alert.ofType.accCreationFailed, message: error!.localizedDescription)
            activityIndicator.stopAnimating()
            registerButton.isEnabled = true
            cancelButton.isEnabled = true
        }else{
            ref = db.collection("users").addDocument(data: [
                "uid": authResult!.user.uid,
                "firstName": firstNameTextField.text!,
                "lastName": lastNameTextField.text!,
                "email": emailTextField.text!,
            ], completion: userSaveToDBHandler(error:))
        }
    }
    
    func userSaveToDBHandler(error: Error?) {
        if error != nil {
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Something went wrong while saving data!")
            activityIndicator.stopAnimating()
            registerButton.isEnabled = true
            cancelButton.isEnabled = true

        } else{
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: signinHandler(result:error:))
        }
    }
    
    //Handles user signin and verifies in Firebase servers.
     func signinHandler(result: AuthDataResult?, error: Error?){
        if error != nil {
            self.presentAlert(Alert.ofType.loginFailed, message: error!.localizedDescription)
            activityIndicator.stopAnimating()
            registerButton.isEnabled = true
            cancelButton.isEnabled = true
        } else {
            dismiss(animated: true, completion: nil)
        }
     }

}

