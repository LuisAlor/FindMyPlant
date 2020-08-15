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

    enum ReuseCellID {
        
        case searchCell
        
        var identifier: String{
            switch self {
            case .searchCell: return "SearchResultsCell"
            }
        }
    }
    
}
