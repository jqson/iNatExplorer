//
//  Species.swift
//  iNatExplorer
//
//  Created by Yuanfeng Jiao on 5/30/25.
//

import Foundation

struct Species: Codable, Equatable {
    
    enum Constants {
        static let preview: Species = .init(
            taxon: .init(id: 6317, name: "", displayName: "Anna's Hummingbird", rank: .species),
            photo: .init(id: 256649705, urlStr: "https://static.inaturalist.org/photos/256649705/square.jpg"),
            ancestors: [
                .init(id: 1, name: "", displayName: "Animals", rank: .kingdom),
                .init(id: 5562, name: "", displayName: "Hummingbirds", rank: .family),
                .init(id: 1542294, name: "", displayName: "Bee Hummingbirds and Allies", rank: .tribe),
            ]
        )
    }
    
    let taxon: Taxon
    let photo: CdnImage?
    let ancestors: [Taxon]
    
    var name: String { taxon.displayName }
}

struct Family {
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
