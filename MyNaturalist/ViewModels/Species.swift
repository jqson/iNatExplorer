//
//  Species.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import Foundation

struct Species: Identifiable {
    
    enum Constants {
        static let preview: Species = .init(
            id: 6317,
            name: "Anna's Hummingbird",
            photo: .init(id: 256649705, urlStr: "https://static.inaturalist.org/photos/256649705/square.jpg")
        )
    }
    
    let id: Int
    let name: String?
    let photo: CdnImage?
}

@MainActor class SpeciesViewModel: ObservableObject {
    
    @Published var species: [Species] = []
    
    func fetchData() async {
        guard let response = await NetworkRequest.getSpeciesCounts() else { return }
        
        species = response.results.map { result in
            .init(
                id: result.taxon.id,
                name: result.taxon.englishCommonName,
                photo: .init(photoResponse: result.taxon.defaultPhoto)
            )
        }
    }
}
