//
//  PlantSpeciesInfoByID.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 24.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

struct PlantSpeciesInfoByID: Codable {
    let mainSpecies: PlantInfo
    
    enum CodingKeys: String, CodingKey{
        case mainSpecies = "main_species"
    }
}
