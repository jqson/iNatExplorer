//
//  RespnoseModels.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/6/24.
//

import Foundation

struct ObservationResponse: Codable {
    
    struct Result: Codable {
        
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
    
    let results: [Result]
}

struct ReverseGeoResponse: Codable {
    struct Result: Codable {
        struct AddressComponent: Codable {
            
            enum ComponentType: String, Codable {
                case streetNumber = "street_number"
                case route
                case postalCode = "postal_code"
                case locality
                case political
                case park
                case other
                
                public init(from decoder: Decoder) throws {
                    guard let rawValue = try? decoder.singleValueContainer().decode(String.self) else {
                        self = .other
                        return
                    }
                    self = ComponentType(rawValue: rawValue) ?? .other
                }
            }
            
            let types: [ComponentType]
        }
        
        let addressComponents: [AddressComponent]
        let formattedAddress: String
    }
    
    let results: [Result]
}
