//
//  SpeciesCount.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import Foundation
import SwiftData
import SwiftUI

struct SpeciesItem: Identifiable {
    
    enum Constants {
        static let preview: SpeciesItem = .init(
            species: Species.Constants.preview,
            count: 1234
        )
    }
    
    let species: Species
    let count: Int?
    let labels: [SavedSpecies.Label]
    let isNew: Bool
    
    var id: Int { species.taxon.id }
    
    init(
        species: Species,
        count: Int? = nil,
        labels: [SavedSpecies.Label] = [],
        isNew: Bool = false
    ) {
        self.species = species
        self.count = count
        self.labels = labels
        self.isNew = isNew
    }
}

struct SpeciesSection: Identifiable {
    let title: String
    let speciesItem: [SpeciesItem]
    
    var id: String { title }
}


@MainActor
@Observable
class SpeciesItemViewModel {
    
    private(set) var speciesSections: [SpeciesSection] = []
    
    var hideObserved: Bool = false {
        didSet {
            UserDefaults.standard.set(hideObserved, forKey: UserDefaultsKeys.hideObservedKey)
            updateSpeciesSections()
        }
    }
    
    var favoriteOnly: Bool = false {
        didSet {
            UserDefaults.standard.set(favoriteOnly, forKey: UserDefaultsKeys.favoriteOnlyKey)
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
    private var speciesItemDict: [Int: SpeciesItem] = [:]  // Species items with counts
    
    init(dataService: SwiftDataService) {
        self.dataService = dataService
        self.hideObserved = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hideObservedKey)
    }
    
    func fetchData(category: CategoryStruct, timeRange: DateUtil.TimeRange) async {
        await fetchSpeciesCounts(category: category, timeRange: timeRange)
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
        
        labels.removeAll { $0 == label }
        updateSpeciesLabels(savedSpecies: savedSpecies, labels: labels)
    }
    
    private func fetchSpeciesCounts(category: CategoryStruct, timeRange: DateUtil.TimeRange) async {
        guard let response = await NetworkRequest.getSpeciesCounts(
            category: category, timeRange: timeRange
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
            $0.species.ancestors.first(where: { $0.rank == .rankClass })?.id == category.classId
        }.reduce(into: [Int: SavedSpecies]()) {
            $0[$1.species.taxon.id] = $1
        }
        
        print("Total saved species: \(savedSpeciesDict.count)")
    }
    
    private func generateFullSpeciesItems() {
        var newSpeciesToSave: [SavedSpecies] = []
        
        var itemDict: [Int: SpeciesItem] = [:]
        for (taxonId, speciesCount) in speciesCountsDict {
            let species = speciesCount.0
            var labels: [SavedSpecies.Label] = []
            var isNew: Bool = false
            if let savedSpecies = savedSpeciesDict[taxonId] {
                labels = savedSpecies.labels
                
                if savedSpecies.species != species {
                    savedSpecies.species = species
                }
                savedSpecies.lastSaved = Date()
                isNew = savedSpecies.newThisYear
            } else {
                newSpeciesToSave.append(.init(species: species, labels: [], lastSaved: Date()))
                isNew = true
            }
            
            itemDict[taxonId] = .init(
                species: species, count: speciesCount.1, labels: labels, isNew: isNew
            )
        }
        
        dataService.addSavedSpecies(newSpeciesToSave)
        dataService.saveChanges()
        
        for savedSpecies in newSpeciesToSave {
            savedSpeciesDict[savedSpecies.species.taxon.id] = savedSpecies
        }
        
        speciesItemDict = itemDict
        
        print("Total species items: \(speciesItemDict.count)")
    }
    
    private func updateSpeciesSections() {
        var speciesToShow: [SpeciesItem] = Array(speciesItemDict.values)
        
        if favoriteOnly {
            speciesToShow.removeAll { !$0.labels.contains(.favorite) }
            
            // Show saved favorited species even if there's no count.
            let savedFavorites: [SavedSpecies] = savedSpeciesDict.values.filter {
                $0.hasLabel(.favorite) && speciesItemDict[$0.species.taxon.id] == nil
            }
            speciesToShow.append(
                contentsOf: savedFavorites.map { .init(species: $0.species, labels: $0.labels) }
            )
        }
        
        if hideObserved {
            speciesToShow.removeAll { $0.labels.contains(.observed) }
        }
        
        let newSpecies: [SpeciesItem] = speciesToShow.filter { $0.isNew }
        speciesToShow.removeAll { $0.isNew }
        
        let families: [Family] = Dictionary(grouping: speciesToShow.map(\.species)) {
            $0.ancestors.first { $0.rank == .family } ?? Taxon.Constants.unknownTaxon
        }.map {
            let familyAncestors: [Taxon] = $1.first?.ancestors.filter({ $0.rank < .family }) ?? []
            return .init(taxon: $0, ancestors: familyAncestors, species: $1)
        }.sorted()
        
        var sections: [SpeciesSection] = families.map { family in
            let speciesItems: [SpeciesItem] = family.species.map { species in
                    .init(
                        species: species,
                        count: speciesCountsDict[species.taxon.id]?.1
                    )
            }.sorted {
                if $0.count == $1.count {
                    return $0.species.taxon.id < $1.species.taxon.id
                }
                
                return $0.count ?? -1 > $1.count ?? -1
            }
            
            return .init(title: family.taxon.displayName, speciesItem: speciesItems)
        }
        
        if !newSpecies.isEmpty {
            sections.insert(
                .init(
                    title: "New for Past Year",
                    speciesItem: newSpecies.sorted {
                        if $0.count == $1.count {
                            return $0.species.taxon.id < $1.species.taxon.id
                        }
                        
                        return $0.count ?? -1 > $1.count ?? -1
                    }
                ),
                at: 0
            )
        }
        
        speciesSections = sections
    }
    
    private func updateSpeciesLabels(savedSpecies: SavedSpecies, labels: [SavedSpecies.Label]) {
        savedSpecies.labels = labels
        dataService.saveChanges()
        
        generateFullSpeciesItems()
        updateSpeciesSections()
    }
}

extension SavedSpecies {
    var newThisYear: Bool {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfToday = calendar.startOfDay(for: now)
        let startOfSavedDate = calendar.startOfDay(for: lastSaved)

        guard startOfSavedDate < startOfToday else {
            return true
        }
        
        guard let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: startOfToday) else {
            return false
        }

        return lastSaved < oneYearAgo
    }
}
