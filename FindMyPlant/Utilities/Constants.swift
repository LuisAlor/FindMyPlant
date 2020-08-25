//
//  Constants.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 25.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

struct Constants{
    
    //Custom UI Colors for easy access thru the project
    enum UICustomColors {
        case darkGreen
        //Get color of type UIColor
        var color: UIColor{
            switch self {
            case .darkGreen:
                return UIColor(red: 46/255, green: 105/255, blue: 47/255, alpha: 1)
            }
        }
    }
    //System icons needed for the app already returned as UIImage
    enum SystemIcons {
        case favoriteIcon
        case favoriteIconFill
        
        var image: UIImage{
            switch self {
            case .favoriteIcon:
                return UIImage(systemName: "star")!
            case .favoriteIconFill:
                return UIImage(systemName: "star.fill")!
            }
        }
    }
    //Segue identifiers for the app
    enum Segues {
        
        case homeToDetails
        case searchToDetails
        case favoritesToDetails
        
        //Returns the identifier for each segue
        var identifier: String{
            switch self {
            case .homeToDetails: return "HomeToDetailsSegue"
            case .searchToDetails: return "SearchToDetailsSegue"
            case .favoritesToDetails: return "FavoritesToDetailsSegue"
            }
        }
    }
    
    enum LabelTextStatus {
        case noSearchResults
        case noSearchDone
        case noFavorites
        
        var message: String {
            switch self {
            case .noSearchResults: return "No Results Found"
            case .noSearchDone: return "Type in the search bar to start"
            case .noFavorites: return "You have no favorite plants yet!"
            }
        }
    }
    
}
