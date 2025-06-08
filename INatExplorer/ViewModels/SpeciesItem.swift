//
//  SpeciesCount.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import Foundation
import SwiftData

struct SpeciesItem: Identifiable {
    
    enum Constants {
        static let preview: SpeciesItem = .init(
            species: Species.Constants.preview,
            count: 1234,
            labels: []
        )
    }
    
    let species: Species
    let count: Int?
    let labels: [SavedSpecies.Label]
    
    var id: Int { species.taxon.id }
}

struct SpeciesSection: Identifiable {
    let title: String
    let speciesItem: [SpeciesItem]
    
    var id: String { title }
}


@MainActor class SpeciesItemViewModel: ObservableObject {
    
    enum Constants {
        static let hideObservedKey = "hideObserved"
    }
    
    @Published private(set) var speciesSections: [SpeciesSection] = []
    
    var hideObserved: Bool = false {
        didSet {
            UserDefaults.standard.set(hideObserved, forKey: Constants.hideObservedKey)
            updateSpeciesSections()
        }
    }
    
    var speciesCountText: String {
        var displayText: String = "Total Species: "
        
        let speciesCount = speciesItemDict.count
        displayText += speciesCount <= 500 ? String(speciesCount) : "500 (max)"
        
        if hideObserved {
            let currentCount = speciesSections.reduce(0) { $0 + $1.speciesItem.count }
            displayText += ", Showing: \(currentCount)"
        }
        
        return displayText
    }
    
    private let dataService: SwiftDataService
    
    private var speciesCountsDict: [Int: (Species, Int)] = [:]  // From server
    private var savedSpeciesDict: [Int: SavedSpecies] = [:]  // Synced with saved data
    private var speciesItemDict: [Int: SpeciesItem] = [:]  // Full species items
    
    init(dataService: SwiftDataService) {
        self.dataService = dataService
        self.hideObserved = UserDefaults.standard.bool(forKey: Constants.hideObservedKey)
    }
    
    func fetchData(category: CategoryStruct) async {
        await fetchSpeciesCounts(category: category)
        loadSavedSpecies(category: category)
        generateFullSpeciesItems()
        updateSpeciesSections()
    }
    
    func hasLabel(species: Species, label: SavedSpecies.Label) -> Bool {
        guard let savedSpecies = savedSpeciesDict[species.taxon.id] else {
            print("Species missing from saved species dictionary!")
            return false
        }
        
        return savedSpecies.hasLabel(label)
    }
    
    func addLabel(species: Species, label: SavedSpecies.Label) {
        guard let savedSpecies = savedSpeciesDict[species.taxon.id] else {
            print("Species missing from saved species dictionary!")
            return
        }
        
        var labels = savedSpecies.labels
        guard !labels.contains(label) else { return }
        
        labels.append(label)
        updateSpeciesLabels(savedSpecies: savedSpecies, labels: labels)
    }
    
    func removeLabel(species: Species, label: SavedSpecies.Label) {
        guard let savedSpecies = savedSpeciesDict[species.taxon.id] else {
            print("Species missing from saved species dictionary!")
            return
        }
        
        var labels = savedSpecies.labels
        guard labels.contains(label) else { return }
        
        labels.removeAll(where: { $0 == label })
        updateSpeciesLabels(savedSpecies: savedSpecies, labels: labels)
    }
    
    private func fetchSpeciesCounts(category: CategoryStruct) async {
        guard let response = await NetworkRequest.getSpeciesCounts(
            category: category, timeRange: .year
        ) else { return }
        
        speciesCountsDict = response.results.reduce(into: [Int: (Species, Int)]()) {
            $0[$1.taxon.id] = (
                Species(
                    taxon: .init(taxonResponse: $1.taxon),
                    photo: .init(photoResponse: $1.taxon.defaultPhoto),
                    ancestors: ($1.taxon.ancestors ?? [])
                        .map({ .init(ancestorResponse: $0) })
                        .filter({ $0.rank != .others })
                ),
                $1.count
            )
        }
        
        print("Species with counts: \(speciesCountsDict.count)")
    }
    
    private func loadSavedSpecies(category: CategoryStruct) {
        savedSpeciesDict = dataService.fetchSavedSpecies().filter {
            guard let rClass = $0.species.ancestors.first(where: { $0.rank == .rankClass }) else {
                return false
            }
            
            return rClass.id == category.classId
        }.reduce(into: [Int: SavedSpecies]()) {
            $0[$1.species.taxon.id] = $1
        }
        
        print("Total saved species: \(savedSpeciesDict.count)")
    }
    
    private func generateFullSpeciesItems() {
        var savedSpeciesToAdd: [SavedSpecies] = []
        var savedSpeciesToDelete: [SavedSpecies] = []
        
        var itemDict: [Int: SpeciesItem] = [:]
        for (taxonId, speciesCount) in speciesCountsDict {
            let species = speciesCount.0
            var labels: [SavedSpecies.Label] = []
            if let savedSpecies = savedSpeciesDict[taxonId] {
                labels = savedSpecies.labels
                
                if savedSpecies.species != species {
                    savedSpeciesToAdd.append(
                        SavedSpecies(species: species, labels: savedSpecies.labels)
                    )
                    savedSpeciesToDelete.append(savedSpecies)
                }
            } else {
                savedSpeciesToAdd.append(.init(species: species, labels: []))
            }
            
            itemDict[taxonId] = .init(species: species, count: speciesCount.1, labels: labels)
        }
        
        dataService.removeSavedSpecies(savedSpeciesToDelete)
        dataService.addSavedSpecies(savedSpeciesToAdd)
        
        for savedSpecies in savedSpeciesToDelete {
            savedSpeciesDict[savedSpecies.species.taxon.id] = nil
        }
        for savedSpecies in savedSpeciesToAdd {
            savedSpeciesDict[savedSpecies.species.taxon.id] = savedSpecies
        }
        
        speciesItemDict = itemDict
        
        print("Total species items: \(speciesItemDict.count)")
    }
    
    private func updateSpeciesSections() {
        var speciesToShow: [SpeciesItem] = Array(speciesItemDict.values)
        if hideObserved {
            speciesToShow.removeAll(where: { $0.labels.contains(.observed) })
        }
        
        let families: [Family] = Dictionary(grouping: speciesToShow.map(\.species)) {
            $0.ancestors.first(where: { $0.rank == .family }) ?? Taxon.Constants.unknownTaxon
        }.map {
            let familyAncestors: [Taxon] = $1.first?.ancestors.filter({ $0.rank < .family }) ?? []
            return .init(taxon: $0, ancestors: familyAncestors, species: $1)
        }.sorted()
        
        speciesSections = families.map { family in
            let speciesItems: [SpeciesItem] = family.species.map { species in
                    .init(
                        species: species,
                        count: speciesCountsDict[species.taxon.id]?.1,
                        labels: speciesItemDict[species.taxon.id]?.labels ?? []
                    )
            }.sorted {
                if $0.count == $1.count {
                    return $0.species.taxon.id < $1.species.taxon.id
                }
                
                return $0.count ?? -1 > $1.count ?? -1
            }
            
            return .init(title: family.taxon.displayName, speciesItem: speciesItems)
        }
    }
    
    private func updateSpeciesLabels(savedSpecies: SavedSpecies, labels: [SavedSpecies.Label]) {
        let newSavedSpecies: SavedSpecies = .init(species: savedSpecies.species, labels: labels)
        
        dataService.removeSavedSpecies([savedSpecies])
        dataService.addSavedSpecies([newSavedSpecies])
        
        savedSpeciesDict[newSavedSpecies.species.taxon.id] = newSavedSpecies
        
        generateFullSpeciesItems()
        updateSpeciesSections()
    }
}
