//
//  Category.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/27/24.
//

import Foundation

enum Category: CaseIterable {
    case bird
    case mammal
    
    var category: CategoryStruct {
        switch self {
        case .bird:
            .init(id: 0, name: "Bird", systemIcon: "bird", paramValue: "Aves")
        case .mammal:
            .init(id: 1, name: "Mammal", systemIcon: "cat", paramValue: "Mammalia")
        }
    }
}

struct CategoryStruct: Identifiable {
    let id: Int
    let name: String
    let systemIcon: String
    let paramValue: String
}
