//
//  FirebaseFMP.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 22.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseFMP{
    
    //Singleton shared variable
    static let shared = FirebaseFMP()
    
    //Properties
    var db: Firestore!
    var user: User!
    var usersRef: CollectionReference!
    var applicationKeysRef: CollectionReference!
    var TrefleAPIKey: String = ""

    //MARK: - configureFirestoreDB: Configure Firestore DB and an userRef to the collection
    func configureFirestoreDB(){
        db = Firestore.firestore()
        usersRef = db.collection("users")
        applicationKeysRef = db.collection("applicationKeys")
    }
    
    //MARK: - configureFramework: Configures Firebase app in the project
    func configureFramework(){
        FirebaseApp.configure()
    }
    
    //MARK: - saveUser: Saves current user details
    func saveUser(_ user: User){
        self.user = user
    }

}
