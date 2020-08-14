//
//  Constants.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 25.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

struct Constants{
    
    enum ReuseCellID {
        
        case searchCell
        case homeHeaderCell
        case homeRandomPlantsCell
        
        var identifier: String{
            switch self {
            case .searchCell: return "SearchResultsCell"
            case .homeHeaderCell: return "HeaderCell"
            case .homeRandomPlantsCell: return "RandomPlantCell"
            }
        }
    }
    
}
