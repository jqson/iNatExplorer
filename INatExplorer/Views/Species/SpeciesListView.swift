//
//  SpeciesListView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI
import SwiftData

struct SpeciesListView: View {
    
    var category: CategoryStruct
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var speciesViewModel = SpeciesViewModel()
    @State private var families: [Family] = []
    @State private var speciesCount: Int = 0
    @State private var isLoading: Bool = true
    
    @Query private var savedSpecies: [SavedSpecies]
    
    private var speciesCountDisplay: String {
        speciesCount <= 500 ? String(speciesCount) : "500 (max)"
    }
    
    private var savedSpeciesDict: [Int: SavedSpecies] {
        Dictionary(uniqueKeysWithValues: savedSpecies.map { ($0.taxonId, $0) })
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                Text("Total species: \(speciesCount)")
                
                LazyVGrid(
                    columns: .init(repeating: GridItem(),count: 3),
                    alignment: .leading
                ) {
                    ForEach(families) { family in
                        Section {
                            ForEach(family.species) { species in
                                NavigationLink(destination: SpeciesDetailView(species: species)) {
                                    SpeciesItemView(
                                        species: species,
                                        isSighted: Binding(
                                            get: {
                                                savedSpeciesDict[species.id]?.hasLabel(.sighted) ?? false
                                            },
                                            set: { newValue in
                                                if newValue {
                                                    addLabel(for: species, label: .sighted)
                                                } else {
                                                    removeLabel(for: species, label: .sighted)
                                                }
                                            }
                                        )
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
                    families = speciesViewModel.families
                    speciesCount = speciesViewModel.speciesCount
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
