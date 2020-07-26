//
//  Constants.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 25.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

struct Constants{
    
    static let displayName = "User-\(Utilities.genRandomNumber())"
    
    enum StoryboardID{
        
        case mainNavController
        case loginController
        case tabController
        case homeController
        case searchController
        case favoritesVC
        
        var identifier: String {
            switch self{
            case .mainNavController: return "mainNavVC"
            case .loginController: return "LoginVC"
            case .tabController: return "TabBarVC"
            case .homeController: return "HomeVC"
            case .searchController: return "SearchVC"
            case .favoritesVC: return "FavoritesVC"
            }
        }
    }
    
    enum StoryboardSegueID{
        case loginToHome
        case regToHome
        
        var identifier: String {
            switch self {
            case .loginToHome: return "loginToHomeSegue"
            case .regToHome: return "regToHomeSegue"
            }
        }
    }
    
    enum ReuseCellID {
        
        case searchCell
        
        var identifier: String{
            switch self {
            case .searchCell: return "searchResultsCell"
            }
        }
    }
    
}
