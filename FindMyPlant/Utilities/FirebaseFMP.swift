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
    
    static let shared = FirebaseFMP()
    
    var db: Firestore!
    var user: User!
    var usersRef: CollectionReference!

    
    func configureFirestoreDB(){
        db = Firestore.firestore()
        usersRef = db.collection("users")
    }
    
    func configureFramework(){
        FirebaseApp.configure()
    }
    
    func saveUser(_ user: User){
        self.user = user
    }

}
