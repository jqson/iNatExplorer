//
//  Taxon.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import Foundation

struct Taxon: Identifiable, Hashable, Codable {
    
    enum Constants {
        static let unknownTaxon: Taxon = .init(id: -1, name: "Unknown", rank: .others)
        
        static let greatHornedOwl: Taxon = .init(id: 20044, name: "Great Horned Owl", rank: .species)
        static let shortEaredOwl: Taxon = .init(id: 20315, name: "Short-eared Owl", rank: .species)
        static let americanBarnOwl: Taxon = .init(id: 1578502, name: "American Barn Owl", rank: .species)
    }
    
    enum Rank: String, Codable {
        case kingdom
        case phylum
        case subphylum
        case classRank = "class"
        case order
        case family
        case subfamily
        case tribe
        case genus
        case species
        case others
    }
    
    let id: Int
    let name: String
    let rank: Rank
}

extension Taxon {
    init(taxonResponse: TaxonResponse) {
        id = taxonResponse.id
        name = taxonResponse.englishCommonName ?? taxonResponse.name
        rank = Taxon.Rank(rawValue: taxonResponse.rank) ?? .others
    }
    
    init(ancestorResponse: TaxonResponse.Ancestor) {
        id = ancestorResponse.id
        name = ancestorResponse.englishCommonName ?? ancestorResponse.name
        rank = Taxon.Rank(rawValue: ancestorResponse.rank) ?? .others
    }
}

struct SelectableTaxon: SelectableItem {
    let taxon: Taxon
    
    var text: String { taxon.name }
    var isSelected: Bool = false
}
