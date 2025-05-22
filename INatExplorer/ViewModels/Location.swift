//
//  Location.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import Foundation

typealias Coordinates = (lat: Double, lng: Double)
typealias AddressComponentType = ReverseGeoResponse.Result.AddressComponent.ComponentType

struct Location {
    
    enum Constants {
        static let addressTypePriority: [AddressComponentType] = [
            .park, .route, .postalCode
        ]
    }
    
    let coordinates: Coordinates
    let displayAddress: String?
}

@MainActor class LocationViewModel: ObservableObject {
    
    @Published private(set) var location: Location? = nil
    
    func fetchData(coordinates: Coordinates) async {
        guard let addressResponse = await NetworkRequest.reverseGeo(coordinates: coordinates) else {
            return
        }
        
        location = .init(
            coordinates: coordinates,
            displayAddress: getDisplayAddress(addressResponse: addressResponse)
        )
    }
    
    private func getDisplayAddress(addressResponse: ReverseGeoResponse) -> String? {
        for componentType in Location.Constants.addressTypePriority {
            for address in addressResponse.results {
                if address.addressComponents.first?.types.contains(componentType) ?? false {
                    return address.formattedAddress
                }
            }
        }
        
        return addressResponse.results.first?.formattedAddress
    }
}
