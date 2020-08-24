//
//  PlantInfo.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

struct PlantInfo: Codable {
    let id: Int
    let slug: String
    let commonName: String?
    let scientificName: String
    let yearRegistered: Int?
    let bibliography: String?
    let author: String?
    let status: String?
    let rank: String
    let familyCommonName: String?
    let genusID: Int
    let imageURL: String?
    let genus: String
    let family: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case slug
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case yearRegistered = "year"
        case bibliography
        case author
        case status
        case rank
        case familyCommonName = "family_common_name"
        case genusID = "genus_id"
        case imageURL = "image_url"
        case genus
        case family
    }
}
