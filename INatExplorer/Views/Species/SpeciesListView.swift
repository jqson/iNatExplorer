//
//  SpeciesListView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI
import SwiftData

struct SpeciesListView: View {
    
    enum Constants {
        static let observedIcon: String = "binoculars.fill"
    }
    
    var category: CategoryStruct
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var speciesViewModel = SpeciesViewModel()
    @State private var isLoading: Bool = true
    
    @Query private var savedSpecies: [SavedSpecies]
    
    @AppStorage("hideObserved") private var hideObserved: Bool = false
    
    private var speciesCountText: String {
        var displayText: String = "Total Species: "
        
        let speciesCount = speciesViewModel.species.count
        displayText += speciesCount <= 500 ? String(speciesCount) : "500 (max)"
        
        if hideObserved {
            displayText += ", Unobserved: \(filteredSpecies.count)"
        }
        
        return displayText
    }
    
    private var savedSpeciesDict: [Int: SavedSpecies] {
        Dictionary(uniqueKeysWithValues: savedSpecies.map { ($0.taxonId, $0) })
    }
    
    private var filteredSpecies: [Species] {
        print("filteredSpecies")
        if hideObserved {
            return speciesViewModel.species.filter {
                !savedSpeciesDict.keys.contains($0.id)
            }
        } else {
            return speciesViewModel.species
        }
    }
    
    private var filteredFamilies: [Family] {
        print("filteredFamilies")
        return Dictionary(grouping: filteredSpecies) {
            $0.ancestors.first(where: { $0.rank == .family }) ?? Taxon.Constants.unknownTaxon
        }.map {
            let familyAncestors: [Taxon] = $1.first?.ancestors.filter({ $0.rank < .family }) ?? []
            return .init(taxon: $0, ancestors: familyAncestors, species: $1)
        }.sorted()
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                Text(speciesCountText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Toggle("Only Show Unobserved", isOn: $hideObserved)
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                
                LazyVGrid(
                    columns: .init(repeating: GridItem(),count: 3),
                    alignment: .leading
                ) {
                    ForEach(filteredFamilies) { family in
                        Section {
                            ForEach(family.species) { species in
                                let observedStatusBinding = Binding(
                                    get: {
                                        savedSpeciesDict[species.id]?.hasLabel(.observed) ?? false
                                    },
                                    set: { newValue in
                                        if newValue {
                                            addLabel(for: species, label: .observed)
                                        } else {
                                            removeLabel(for: species, label: .observed)
                                        }
                                    }
                                )
                                
                                NavigationLink {
                                    SpeciesDetailView(
                                        species: species,
                                        observed: observedStatusBinding
                                    )
                                } label: {
                                    SpeciesItemView(
                                        species: species,
                                        observed: observedStatusBinding
                                    )
                                }
                                .navigationTitle("Species List")
                            }
                        } header: {
                            HStack {
                                Text(family.taxon.displayName)
                                    .bold()
                                
                                Spacer()
                                
                                UpdateFilterButtonView(taxon: family.taxon)
                            }
                            .padding([.leading, .trailing, .top])
                            .padding(.bottom, 8)
                        }
                    }
                }
                .task {
                    guard isLoading else { return }
                    
                    await speciesViewModel.fetchData(category: category)
                    isLoading = false
                }
            }
            
            ZStack {
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .scaleEffect(2)
            }
            .opacity(isLoading ? 1 : 0)
        }
    }
    
    private func addLabel(for species: Species, label: SavedSpecies.Label) {
        let taxonId = species.taxon.id
        if savedSpeciesDict[taxonId] != nil {
            savedSpecies.first(where: { $0.taxonId == taxonId })?.addLabel(label)
        } else {
            modelContext.insert(SavedSpecies(taxonId: taxonId, labels: [label]))
        }
    }
    
    private func removeLabel(for species: Species, label: SavedSpecies.Label) {
        guard let savedSpeciesItem = savedSpecies.first(where: { $0.taxonId == species.taxon.id })
        else { return }
        
        savedSpeciesItem.removeLabel(label)
        if savedSpeciesItem.labels.isEmpty {
            modelContext.delete(savedSpeciesItem)
        }
        try? modelContext.save()
    }
}

#Preview {
    SpeciesListView(category: Category.bird.category)
}
