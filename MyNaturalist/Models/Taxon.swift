//
//  Taxon.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import Foundation

enum Taxon {
    case greatHornedOwl
    case shortEaredOwl
    case americanBarnOwl
    case other(TaxonStruct)
    
    var info: TaxonStruct {
        switch self {
        case .greatHornedOwl:
            .init(id: 20044, name: "Great Horned Owl")
        case .shortEaredOwl:
            .init(id: 20315, name: "Short-eared Owl")
        case .americanBarnOwl:
            .init(id: 1578502, name: "American Barn Owl")
        case .other(let taxon):
            taxon
        }
    }
}

struct TaxonStruct: SelectableItem {
    let id: Int
    let name: String
    
    var text: String { name }
    var selected: Bool = false
}
