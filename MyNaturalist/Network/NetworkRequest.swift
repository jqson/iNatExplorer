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
        static let endPoint = "/observations?verifiable=true&order_by=id&order=desc&page=1&spam=false&locale=en-US&ttl=3600&per_page=5&taxon_id=19350"
    }
    
    static func getObservations() async -> ObservationResponse? {
        let requestUrl = Constants.baseUrl + Observation.endPoint
        return try? await NetworkService.sendRequest(fromUrl: requestUrl)
    }
}
