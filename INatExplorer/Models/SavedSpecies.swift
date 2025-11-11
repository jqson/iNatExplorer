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
        case favorite
    }
    
    var species: Species
    var labels: [Label]
    var lastSaved: Date = Date()
    
    init(species: Species, labels: [Label], lastSaved: Date) {
        self.species = species
        self.labels = labels
        self.lastSaved = lastSaved
    }
    
    func hasLabel(_ label: Label) -> Bool {
        return labels.contains(label)
    }
    
    func addLabel(_ label: Label) {
        guard !labels.contains(label) else { return }
        
        self.labels.append(label)
    }
    
    func removeLabel(_ label: Label) {
        self.labels.removeAll { $0 == label }
    }
}
