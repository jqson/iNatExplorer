//
//  NetworkRequest.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/6/24.
//

import Foundation

class NetworkRequest {
    
    enum Constants {
        static let baseUrl = "https://api.inaturalist.org/v1"
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
        let requestUrl = URL(string: Constants.baseUrl + Observation.endPoint)
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func getPlaces(placeIds: Set<Int>) async -> PlacesResponse? {
        var requestURL = URL(string: Constants.baseUrl + Places.endPoint)
        requestURL?.appendPathComponent(Array(placeIds).map({ String($0) }).joined(separator: ","))
        return try? await NetworkService.sendRequest(url: requestURL)
    }
}
