//
//  RespnoseModels.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/6/24.
//

import Foundation

struct ObservationResponse: Codable {
    
    struct Result: Codable {
        struct ObservationPhoto: Codable {
            let photo: PhotoResponse
        }
        
        struct GeoJson: Codable {
            let type: String
            let coordinates: [Double]
        }
        
        let id: Int
        let observedOnString: String
        let taxon: TaxonResponse?
        let observationPhotos: [ObservationPhoto]
        let geojson: GeoJson
        let description: String?
        let uri: String
    }
    
    let results: [Result]
}

struct SpeciesCountsResponse: Codable {
    
    struct Result: Codable {
        let count: Int
        let taxon: TaxonResponse
    }
    
    let results: [Result]
}

struct TaxonResponse: Codable {
    struct Ancestor: Codable {
        let id: Int
        let rank: String
        let name: String
        let englishCommonName: String?
    }
    
    let id: Int
    let rank: String
    let name: String
    let englishCommonName: String?
    let defaultPhoto: PhotoResponse
    let ancestors: [Ancestor]?
}
    
struct PhotoResponse: Codable {
    let id: Int
    let url: String
}

struct TaxonNameResponse: Codable {
    let id: Int
    let parameterizedLexicon: String
    let name: String
}

struct HistogramResponse: Codable {
    struct Result: Codable {
        let day: [String: Int]?
        let weekOfYear: [String: Int]?
    }
    
    let results: Result
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
