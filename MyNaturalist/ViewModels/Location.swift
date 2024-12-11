//
//  Location.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import Foundation

typealias Coordinates = (lat: Double, lng: Double)

struct Location {
    
    enum AddressComponents: String {
        case streetNumber = "street_number"
        case route
        case postalCode = "postal_code"
        case locality
        case political
    }
    
    let coordinates: Coordinates
    let displayAddress: String?
}

@MainActor class LocationViewModel: ObservableObject {
    
    @Published var location: Location? = nil
    
    func fetchData(coordinates: Coordinates) async {
        guard let addressResponse = await NetworkRequest.getAddress(coordinates: coordinates) else {
            return
        }
        
        location = .init(
            coordinates: coordinates,
            displayAddress: addressResponse.results.first?.formattedAddress
        )
    }
}
