//
//  PlantsSearchResponse.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 02.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

struct PlantsSearchResponse: Codable {
    let data: [PlantInfo]
    let links: PlantLinks
    let meta: PlantMeta
}

