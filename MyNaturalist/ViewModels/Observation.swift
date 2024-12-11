//
//  Observation.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import Foundation

struct Observation: Identifiable {
    
    enum Constants {
        static let preview: Observation = .init(
            id: 252658676,
            name: "Barking Owl",
            observedTime: "2024-09-12T18:10:00+09:30",
            photos: [.init(id: 456279884, urlStr: "https://inaturalist-open-data.s3.amazonaws.com/photos/363572869/square.jpeg")!],
            placeName: "arnhem land tropical savanna"
        )
    }
    
    
    let id: Int
    let name: String
    let observedTime: String
    let photos: [CdnImage]
    let placeName: String?
}

@MainActor class ObservationViewModel: ObservableObject {
    
    @Published var observations = [Observation]()
    
    func fetchData() async {
        guard let observationResponse = await NetworkRequest.getObservations() else {
            return
        }
        
        let placeIds: Set<Int> = Set(observationResponse.results.compactMap({ $0.placeIds.last }))
        if let placesResponse = await NetworkRequest.getPlaces(placeIds: placeIds) {
            let placeDict = placesResponse.results.reduce(into: [Int: String]()) {
                $0[$1.id] = $1.displayName
            }
            
            PlaceManager.shared.addPlaces(placeDict)
        }
        
        observations = observationResponse.results.map { result in
            .init(
                id: result.id,
                name: result.taxon.englishCommonName,
                observedTime: result.observedOnString,
                photos: result.observationPhotos.compactMap({
                    .init(id: $0.photo.id, urlStr: $0.photo.url)
                }),
                placeName: PlaceManager.shared.getPlace(id: result.placeIds.last)
            )
        }
    }
}
