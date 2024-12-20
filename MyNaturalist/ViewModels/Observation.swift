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
            photos: [.init(id: 363572869, urlStr: "https://inaturalist-open-data.s3.amazonaws.com/photos/363572869/square.jpeg")!],
            coordinates: (lat: 38.20608, lng: -122.75155)
        )
    }
    
    
    let id: Int
    let name: String
    let observedTime: String
    let photos: [CdnImage]
    let coordinates: Coordinates
}

@MainActor class ObservationViewModel: ObservableObject {
    
    @Published var observations = [Observation]()
    
    func fetchData(taxons: [Taxon] = []) async {
        guard let observationResponse = await NetworkRequest.getObservations(taxons: taxons) else {
            return
        }
        
        observations = observationResponse.results.map { result in
            .init(
                id: result.id,
                name: result.taxon?.englishCommonName ?? "Unknown",
                observedTime: result.observedOnString,
                photos: result.observationPhotos.compactMap({
                    .init(id: $0.photo.id, urlStr: $0.photo.url)
                }),
                coordinates: (lat: result.geojson.coordinates[1], lng: result.geojson.coordinates[0])
            )
        }
    }
}
