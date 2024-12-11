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
        static let geoCodeBaseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
        static let gmsKey = "AIzaSyDQPAmqBULGhHwOj8LPrsHSTn-r-bYfKo4"
    }
    
    enum Observation {
        static let endPoint = "/observations?verifiable=true&order_by=observed_on&order=desc&page=1&photos=true"
            + "&nelat=37.8764014352312&nelng=-121.57421471187659&swlat=36.89876283035327&swlng=-122.64812828609534"
            + "&taxon_id=19350&locale=en-US&per_page=20&return_bounds=true"
    }
    
    enum Places {
        static let endPoint = "/places/"
    }
    
    static func getObservations() async -> ObservationResponse? {
        let requestUrl = URL(string: Constants.iNatBaseUrl + Observation.endPoint)
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func getPlaces(placeIds: Set<Int>) async -> PlacesResponse? {
        var requestURL = URL(string: Constants.iNatBaseUrl + Places.endPoint)
        requestURL?.appendPathComponent(Array(placeIds).map({ String($0) }).joined(separator: ","))
        return try? await NetworkService.sendRequest(url: requestURL)
    }
    
    static func getAddress(coordinates: Coordinates) async -> ReverseGeoResponse? {
        let queryItems: [URLQueryItem] = [
            .init(name: "key", value: Constants.gmsKey),
            .init(name: "latlng", value: "\(coordinates.lat),\(coordinates.lng)")
        ]
        
        var requestUrl = URL(string: Constants.geoCodeBaseUrl)
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
}
