//
//  Species.swift
//  INatExplorer
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
    let ancestors: [Taxon]
    let species: [Species]
    
    var id: Int { taxon.id }
}

extension Family: Comparable {
    static func == (lhs: Family, rhs: Family) -> Bool {
        lhs.taxon == rhs.taxon
    }
    
    static func < (lhs: Family, rhs: Family) -> Bool {
        let lRankIdx = AosFamilyOrder.shared.familyOrder[lhs.taxon.name]
        let rRankIdx = AosFamilyOrder.shared.familyOrder[rhs.taxon.name]
        
        if let lRankIdx = lRankIdx, let rRankIdx = rRankIdx {
            return lRankIdx < rRankIdx
        }
        
        guard lRankIdx == nil, rRankIdx == nil else {
            return rRankIdx == nil
        }
        
        for rank in Taxon.Constants.rankOrder {
            guard
                let lRank = lhs.ancestors.first(where: { $0.rank == rank }),
                let rRank = rhs.ancestors.first(where: { $0.rank == rank })
            else {
                break
            }
            
            if lRank != rRank {
                return lRank.id < rRank.id
            }
        }
        
        return lhs.id < rhs.id
    }
}

@MainActor class SpeciesViewModel: ObservableObject {
    
    @Published private(set) var species: [Species] = []
    
    func fetchData(category: CategoryStruct) async {
        guard let response = await NetworkRequest.getSpeciesCounts(category: category) else { return }
        
        species = response.results.map { result in
            .init(
                taxon: .init(taxonResponse: result.taxon),
                photo: .init(photoResponse: result.taxon.defaultPhoto),
                count: result.count,
                ancestors: (result.taxon.ancestors ?? [])
                    .map({ .init(ancestorResponse: $0) })
                    .filter({ $0.rank != .others })
            )
        }.sorted(by: { $0.count > $1.count})
    }
}
