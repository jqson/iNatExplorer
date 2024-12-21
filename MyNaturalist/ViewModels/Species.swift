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
            photo: .init(id: 256649705, urlStr: "https://static.inaturalist.org/photos/256649705/square.jpg"),
            count: 1234,
            ancestors: []
        )
    }
    
    let id: Int
    let name: String
    let photo: CdnImage?
    let count: Int
    let ancestors: [Taxon]
}

struct Family: Identifiable {
    let taxon: Taxon
    let species: [Species]
    
    var id: Int { taxon.id }
}

@MainActor class SpeciesViewModel: ObservableObject {
    
    @Published var families: [Family] = []
    private(set) var speciesCount: Int = 0
    
    func fetchData() async {
        guard let response = await NetworkRequest.getSpeciesCounts() else { return }
        
        var species: [Species] = response.results.map { result in
            .init(
                id: result.taxon.id,
                name: result.taxon.englishCommonName ?? "Unknown",
                photo: .init(photoResponse: result.taxon.defaultPhoto),
                count: result.count,
                ancestors: result.taxon.ancestors.map {
                    .init(
                        id: $0.id,
                        name: $0.englishCommonName ?? $0.name,
                        rank: Taxon.Rank(rawValue: $0.rank) ?? .others
                    )
                }
            )
        }
        
        speciesCount = species.count
        
        species.sort(by: { $0.name < $1.name})
        
        families = Dictionary(grouping: species) {
            $0.ancestors.first(where: { $0.rank == .family }) ?? Taxon.Constants.unknownTaxon
        }.map {
            .init(taxon: $0, species: $1)
        }.sorted {
            $0.taxon.id < $1.taxon.id
        }
    }
}
