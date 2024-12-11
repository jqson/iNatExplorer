//
//  RespnoseModels.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/6/24.
//

import Foundation

struct ObservationResponse: Codable {
    struct Results: Codable {
        struct Taxon: Codable {
            let englishCommonName: String
        }
        
        struct ObservationPhoto: Codable {
            struct Photo: Codable {
                let id: Int
                let url: String
            }
            
            let photo: Photo
        }
        
        let id: Int
        let observedOnString: String
        let taxon: Taxon
        let observationPhotos: [ObservationPhoto]
        let placeIds: [Int]
    }
    
    let results: [Results]
}

struct PlacesResponse: Codable {
    struct Results: Codable {
        let id: Int
        let displayName: String
    }
    
    let results: [Results]
}
