//
//  Filter.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 1/17/25.
//

import Foundation
import SwiftData

protocol SelectableItem {
    var text: String { get }
    var isSelected: Bool { get set }
}

enum FilterType: Codable, Equatable {
    case taxon(Taxon)
    
    var text: String {
        switch self {
        case .taxon(let taxon):
            return taxon.displayName
        }
    }
    
    var section: FilterView.FilterSection {
        switch self {
        case .taxon(_):
            return .taxon
        }
    }
}

@Model
class Filter {
    var filterType: FilterType
    var isSelected: Bool
    
    init(filterType: FilterType, isSelected: Bool) {
        self.filterType = filterType
        self.isSelected = isSelected
    }
}

extension Filter: SelectableItem {
    var text: String {
        filterType.text
    }
}
