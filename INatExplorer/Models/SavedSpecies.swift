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
        case observed
    }
    
    var species: Species
    var labels: [Label]
    
    init(species: Species, labels: [Label]) {
        self.species = species
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
