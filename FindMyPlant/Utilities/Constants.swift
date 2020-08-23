//
//  Constants.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 25.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

struct Constants{
    
    enum UICustomColors {
        case darkGreen
        var color: UIColor{
            switch self {
            case .darkGreen:
                return UIColor(red: 46/255, green: 105/255, blue: 47/255, alpha: 1)
            }
        }
    }
    
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

    enum Segues {
        
        case homeToDetails
        case searchToDetails
        case favoritesToDetails
        
        var identifier: String{
            switch self {
            case .homeToDetails: return "HomeToDetailsSegue"
            case .searchToDetails: return "SearchToDetailsSegue"
            case .favoritesToDetails: return "FavoritesToDetailsSegue"
            }
        }
    }
    
    enum SearchStatus {
        case noResults
        case noSearch
        
        var message: String {
            switch self {
            case .noResults: return "No Results Found"
            case .noSearch: return "Type in the search bar to start"
            }
        }
    }
    
}
