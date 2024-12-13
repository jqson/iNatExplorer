//
//  Taxon.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import Foundation

enum Taxon: CaseIterable {
    case greatHornedOwl
    case shortEaredOwl
    case americanBarnOwl
    
    var info: TaxonStruct {
        switch self {
        case .greatHornedOwl:
            .init(id: 20044, name: "Great Horned Owl", taxon: self)
        case .shortEaredOwl:
            .init(id: 20315, name: "Short-eared Owl", taxon: self)
        case .americanBarnOwl:
            .init(id: 1578502, name: "American Barn Owl", taxon: self)
        }
    }
}

struct TaxonStruct: SelectableItem {
    let id: Int
    let name: String
    let taxon: Taxon
    
    var text: String { name }
    var isSelected: Bool = false
}
