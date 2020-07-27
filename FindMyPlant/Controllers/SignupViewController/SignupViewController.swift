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

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
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
    
    fileprivate func setupInterface(){
        
        Utilities.styleFilledButton(registerButton)
        Utilities.styleFilledButton(cancelButton)
        
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
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !firstName.isEmpty else {
            self.presentAlert(Alert.ofType.accCreationFailed, message: "First name field is empty.")
            return
        }
        guard !lastName.isEmpty else {
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Last name field is empty.")
            return
        }
        guard !email.isEmpty else {
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Email field is empty.")
            return
        }
        guard !password.isEmpty else {
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Password field is empty.")
            return
        }
        guard Utilities.isPasswordValid(password) else {
            self.presentAlert(Alert.ofType.accCreationFailed, message: "Password must be at least 6 characters long and must include one capital letter and one special character.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: createUserHandler(authResult:error:))
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Handle Firebase user creation from completionHandler
    func createUserHandler(authResult: AuthDataResult?, error: Error?){
        if error != nil {
            self.presentAlert(Alert.ofType.accCreationFailed, message: error!.localizedDescription)
        }else{
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: signinHandler(result:error:))
        }
    }
    
    //Handles user signin and verifies in Firebase servers.
    func signinHandler(result: AuthDataResult?, error: Error?){
       if error != nil {
           self.presentAlert(Alert.ofType.loginFailed, message: error!.localizedDescription)
       }
    }

}

