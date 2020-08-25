//
//  Alert.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 25.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

// Alert class to customize the titles of our alertview

class Alert{
    
    //Titles for the custom alerts
    struct Titles {
        let ofController: String
        let ofAction: String
    }
    
    //Type of alerts in the app
    enum ofType {
        case loginFailed
        case accCreationFailed
        case passwordBadFormat
        case emptyFields
        case failedToRetrieveDataFromServer
        case failedToSetDataToServer

        //Get the title for the alert and action text
        var getTitles: Titles{
            switch self {
            case .loginFailed:
                return Titles(ofController: "Login Failed", ofAction: "Try Again")
            case .accCreationFailed:
                return Titles(ofController: "Account Creation Failed", ofAction: "Try Again")
            case .passwordBadFormat:
                return Titles(ofController: "Wrong Password Format", ofAction: "Try Again")
            case .emptyFields:
                return Titles(ofController: "Empty Fields", ofAction: "Try Again")
            case .failedToRetrieveDataFromServer:
                return Titles(ofController: "Failed to Retrieve Data", ofAction: "Dismiss")
            case .failedToSetDataToServer:
                return Titles(ofController: "Failed to Set Data", ofAction: "Dismiss")
            }
        }
    }
}
