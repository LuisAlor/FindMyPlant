//
//  SceneDelegate.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 19.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var handle:AuthStateDidChangeListenerHandle!
    var userLoggedUponLaunch: Bool = true

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    
//        handle = Auth.auth().addStateDidChangeListener(authListenerHandler(auth:user:))
    }
    
    //Handles addStateDidChangeListener and sets a new Root View as Key
//    func authListenerHandler(auth: Auth, user: User?){
//
//        guard let window = self.window else { return }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabToHome = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
//
//        if user != nil{
//            if window.rootViewController is LoginViewController && userLoggedUponLaunch{
//                window.rootViewController = tabToHome
//                window.makeKeyAndVisible()
//            } else {
//                window.rootViewController = tabToHome
//                window.makeKeyAndVisible()
//                UIView.transition(with: window,
//                                  duration: 0.5,
//                                  options: [.transitionFlipFromRight],
//                                  animations: nil,
//                                  completion: nil)
//            }
//        }else {
//            userLoggedUponLaunch = false
//        }
//    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        //Removes auth listener during deinitialization
//        Auth.auth().removeStateDidChangeListener(handle)
    }

}

