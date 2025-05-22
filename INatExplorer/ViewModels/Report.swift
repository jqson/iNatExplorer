//
//  Report.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import Foundation

struct Report: Identifiable {
    
    enum Constants {
        static let preview: Report = .init(
            id: 252658676,
            taxon: Taxon.Constants.greatHornedOwl,
            observedTime: "2024-09-12T18:10:00+09:30",
            description: "Some description.",
            webLink: URL(string: "https://www.inaturalist.org/observations/252658676"),
            photos: [.init(id: 363572869, urlStr: "https://inaturalist-open-data.s3.amazonaws.com/photos/363572869/square.jpeg")!],
            coordinates: (lat: 38.20608, lng: -122.75155)
        )
    }
    
    
    let id: Int
    let taxon: Taxon?
    let observedTime: String
    let description: String?
    let webLink: URL?
    let photos: [CdnImage]
    let coordinates: Coordinates
    
    var name: String {
        taxon?.displayName ?? "Unknown"
    }
}

@MainActor class ReportViewModel: ObservableObject {
    
    @Published private(set) var reports: [Report] = []
    
    func fetchData(taxons: [Taxon] = []) async {
        guard let observationResponse = await NetworkRequest.getObservations(taxons: taxons) else {
            return
        }
        
        reports = observationResponse.results.map { result in
            var taxon: Taxon?
            if let observationTaxon = result.taxon {
                taxon = .init(taxonResponse: observationTaxon)
            }
            return .init(
                id: result.id,
                taxon: taxon,
                observedTime: result.observedOnString,
                description: result.description,
                webLink: URL(string: result.uri),
                photos: result.observationPhotos.compactMap({ .init(photoResponse: $0.photo) }),
                coordinates: (lat: result.geojson.coordinates[1], lng: result.geojson.coordinates[0])
            )
        }
    }
}
