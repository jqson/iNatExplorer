//
//  SavedSpecies.swift
//  iNatExplorer
//
//  Created by Yuanfeng Jiao on 5/27/25.
//

import Foundation
import SwiftData

@Model
class SavedSpecies {
    
    enum Label: Codable {
        case sighted
    }
    
    var taxonId: Int
    var labels: [Label]
    
    init(taxonId: Int, labels: [Label]) {
        self.taxonId = taxonId
        self.labels = labels
    }
    
    func hasLabel(_ label: Label) -> Bool {
        return labels.contains(label)
    }
    
    func addLabel(_ label: Label) {
        guard !labels.contains(label) else { return }
        
        self.labels.append(label)
    }
    
    func removeLabel(_ label: Label) {
        self.labels.removeAll(where: { $0 == label })
    }
}
