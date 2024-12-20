//
//  NetworkRequest.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/6/24.
//

import Foundation

class NetworkRequest {
    
    enum Constants {
        static let iNatBaseUrl = "https://api.inaturalist.org/v1"
        
        static let gmsKey = "AIzaSyDQPAmqBULGhHwOj8LPrsHSTn-r-bYfKo4"
        static let geoCodeBaseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    }
    
    enum Observation {
        static let endPoint = "/observations?verifiable=true&order_by=observed_on&order=desc&page=1&photos=true"
            + "&nelat=37.8764014352312&nelng=-121.57421471187659&swlat=36.89876283035327&swlng=-122.64812828609534"
            + "&locale=en-US&return_bounds=true"
        
        static let taxonIdKey = "taxon_id"
        static let perPageKey = "per_page"
    }
    
    enum SpeciesCounts {
        static let endPoint = "/observations/species_counts?verifiable=true&spam=false"
            + "&nelat=37.8764014352312&nelng=-121.57421471187659&swlat=36.89876283035327&swlng=-122.64812828609534"
            + "&iconic_taxa%5B%5D=Aves&locale=en-US&include_ancestors=true"
        
        static let perPageKey = "per_page"
        static let fromDate = "d1"
    }
    
    enum ReverseGeo {
        static let keyKey = "key"
        static let coordinatesKey = "latlng"
    }
    
    static func getObservations(taxons: [Taxon]) async -> ObservationResponse? {
        var requestUrl = URL(string: Constants.iNatBaseUrl + Observation.endPoint)
        var queryItems: [URLQueryItem] = []
        
        if !taxons.isEmpty {
            let taxonIdValue = taxons.map({ String($0.info.id) }).joined(separator: ",")
            queryItems.append(.init(name: Observation.taxonIdKey, value: taxonIdValue))
        }
        
        queryItems.append(.init(name: Observation.perPageKey, value: "20"))
        
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func getSpeciesCounts() async -> SpeciesCountsResponse? {
        var requestUrl = URL(string: Constants.iNatBaseUrl + SpeciesCounts.endPoint)
        let queryItems: [URLQueryItem] = [
//            .init(name: SpeciesCounts.perPageKey, value: "5"),
            .init(name: SpeciesCounts.fromDate, value: "2024-01-01"),
        ]
        
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func reverseGeo(coordinates: Coordinates) async -> ReverseGeoResponse? {
        let queryItems: [URLQueryItem] = [
            .init(name: ReverseGeo.keyKey, value: Constants.gmsKey),
            .init(name: ReverseGeo.coordinatesKey, value: "\(coordinates.lat),\(coordinates.lng)"),
        ]
        
        var requestUrl = URL(string: Constants.geoCodeBaseUrl)
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
}
