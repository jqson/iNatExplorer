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
        
        struct GeoJson: Codable {
            let type: String
            let coordinates: [Double]
        }
        
        let id: Int
        let observedOnString: String
        let taxon: Taxon
        let observationPhotos: [ObservationPhoto]
        let geojson: GeoJson
    }
    
    let results: [Results]
}

struct ReverseGeoResponse: Codable {
    struct Results: Codable {
        let formattedAddress: String
    }
    
    let results: [Results]
}
