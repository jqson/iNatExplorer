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
            taxon: .init(id: 6317, name: "", displayName: "Anna's Hummingbird", rank: .species),
            photo: .init(id: 256649705, urlStr: "https://static.inaturalist.org/photos/256649705/square.jpg"),
            count: 1234,
            ancestors: [
                .init(id: 1, name: "", displayName: "Animals", rank: .kingdom),
                .init(id: 5562, name: "", displayName: "Hummingbirds", rank: .family),
                .init(id: 1542294, name: "", displayName: "Bee Hummingbirds and Allies", rank: .tribe),
            ]
        )
    }
    
    let taxon: Taxon
    let photo: CdnImage?
    let count: Int
    let ancestors: [Taxon]
    
    var id: Int { taxon.id }
    var name: String { taxon.displayName }
}

struct Family: Identifiable {
    let taxon: Taxon
    let species: [Species]
    
    var id: Int { taxon.id }
}

//extension Family: Comparable {
//    static func == (lhs: Family, rhs: Family) -> Bool {
//        lhs.taxon == rhs.taxon
//    }
//    
//    static func < (lhs: Family, rhs: Family) -> Bool {
//        for rank in Taxon.Constants.rankOrder {
//            guard
//                let lRank = lhs.ancestors.first(where: { $0.rank == rank }),
//                let rRank = rhs.ancestors.first(where: { $0.rank == rank })
//            else {
//                break
//            }
//            
//            if lRank != rRank {
//                return lRank.id < rRank.id
//            }
//        }
//        
//        return lhs.id < rhs.id
//    }
//}

@MainActor class SpeciesViewModel: ObservableObject {
    
    @Published private(set) var families: [Family] = []
    private(set) var speciesCount: Int = 0
    
    func fetchData(category: CategoryStruct) async {
        guard let response = await NetworkRequest.getSpeciesCounts(category: category) else { return }
        
        var species: [Species] = response.results.map { result in
            .init(
                taxon: .init(taxonResponse: result.taxon),
                photo: .init(photoResponse: result.taxon.defaultPhoto),
                count: result.count,
                ancestors: (result.taxon.ancestors ?? [])
                    .map({ .init(ancestorResponse: $0) })
                    .filter({ $0.rank != .others })
            )
        }
        
        speciesCount = species.count
        
        species.sort(by: { $0.count > $1.count})
        
        families = Dictionary(grouping: species) {
            $0.ancestors.first(where: { $0.rank == .family }) ?? Taxon.Constants.unknownTaxon
        }.map {
            .init(taxon: $0, species: $1)
        }.sorted {
            $0.taxon.id < $1.taxon.id
        }
    }
}
