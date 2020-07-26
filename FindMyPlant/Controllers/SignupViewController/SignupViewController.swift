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

    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
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
        
        //navigationItem.hidesBackButton = true

    }
    
    @IBAction func registerAccount(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().createUser(withEmail: email, password: password, completion: createUserHandler(authResult:error:))
        
    }
    
    //Handle Firebase user creation from completionHandler
    func createUserHandler(authResult: AuthDataResult?, error: Error?){
        if error != nil {
            self.presentAlert(Alert.ofType.accCreationFailed, message: error!.localizedDescription)
        }else{
           performSegue(withIdentifier: "registrationSegue", sender: nil)
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: signinHandler(result:error:))
        }
    }
    
    //Handles user signin and verifies in Firebase servers.
    func signinHandler(result: AuthDataResult?, error: Error?){
       if error != nil {
           self.presentAlert(Alert.ofType.loginFailed, message: error!.localizedDescription)
       }else{
           performSegue(withIdentifier: "regToHomeSegue", sender: nil)
       }
    }

}

