//
//  Taxon.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import Foundation

struct Taxon: Identifiable, Hashable, Codable {
    
    enum Constants {
        static let rankOrder: [Rank] = [
            .kingdom,
            .phylum,
            .subphylum,
            .rankClass,
            .order,
            .family,
            .subfamily,
            .tribe,
            .genus,
            .species,
            .others
        ]
        
        static let unknownTaxon: Taxon = .init(id: -1, name: "Unknown", displayName: "Unknown", rank: .others)
        
        static let greatHornedOwl: Taxon = .init(id: 20044, name: "", displayName: "Great Horned Owl", rank: .species)
        static let shortEaredOwl: Taxon = .init(id: 20315, name: "", displayName: "Short-eared Owl", rank: .species)
        static let americanBarnOwl: Taxon = .init(id: 1578502, name: "", displayName: "American Barn Owl", rank: .species)
    }
    
    enum Rank: String, Codable, Comparable {
        case kingdom
        case phylum
        case subphylum
        case rankClass = "class"
        case order
        case family
        case subfamily
        case tribe
        case genus
        case species
        case others
        
        static func < (lhs: Rank, rhs: Rank) -> Bool {
            Constants.rankOrder.firstIndex(of: lhs)! > Constants.rankOrder.firstIndex(of: rhs)!
        }
    }
    
    let id: Int
    let name: String
    let displayName: String
    let rank: Rank
}

extension Taxon {
    init(taxonResponse: TaxonResponse) {
        id = taxonResponse.id
        name = taxonResponse.name
        displayName = taxonResponse.englishCommonName ?? taxonResponse.name
        rank = Taxon.Rank(rawValue: taxonResponse.rank) ?? .others
    }
    
    init(ancestorResponse: TaxonResponse.Ancestor) {
        id = ancestorResponse.id
        name = ancestorResponse.name
        displayName = ancestorResponse.englishCommonName ?? ancestorResponse.name
        rank = Taxon.Rank(rawValue: ancestorResponse.rank) ?? .others
    }
}
