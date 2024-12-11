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
        static let endPoint = "/observations?verifiable=true&order_by=observed_on&order=desc&page=1&spam=false&pnelat=38.8643&nelng=-121.208178&swlat=36.8929759&swlng=-123.632497&taxon_id=19350&locale=en-US&per_page=5&return_bounds=true"
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
