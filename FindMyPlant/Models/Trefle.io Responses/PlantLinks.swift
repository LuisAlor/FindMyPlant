//
//  PlantLinks.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

struct PlantLinks: Codable {
    let current: String
    let first: String
    let last: String
    
    enum CodingKeys: String, CodingKey{
        case current = "self"
        case first
        case last
    }
}
