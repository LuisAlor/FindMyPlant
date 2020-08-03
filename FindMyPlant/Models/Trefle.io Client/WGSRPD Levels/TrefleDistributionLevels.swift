//
//  TrefleDistributionLevels.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 01.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import Foundation

enum TrefleDistributionLevels {
    
    case L1 (zone: L1)
    
    var zone: String {
        switch self {
        case let .L1 (zone):
            return zone.rawValue
        }
    }
}

