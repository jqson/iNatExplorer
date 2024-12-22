//
//  Taxon.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import Foundation

struct Taxon: Identifiable, Hashable {
    
    enum Constants {
        static let unknownTaxon: Taxon = .init(id: -1, name: "Unknown", rank: .others)
        
        static let greatHornedOwl: Taxon = .init(id: 20044, name: "Great Horned Owl", rank: .species)
        static let shortEaredOwl: Taxon = .init(id: 20315, name: "Short-eared Owl", rank: .species)
        static let americanBarnOwl: Taxon = .init(id: 1578502, name: "American Barn Owl", rank: .species)
    }
    
    enum Rank: String {
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

struct SelectableTaxon: SelectableItem {
    let taxon: Taxon
    
    var text: String { taxon.name }
    var isSelected: Bool = false
}
