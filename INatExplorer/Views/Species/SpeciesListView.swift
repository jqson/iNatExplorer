//
//  SpeciesListView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesListView: View {
    
    enum Constants {
        static let observedIcon: String = "binoculars.fill"
    }
    
    var category: CategoryStruct
    
    @StateObject private var speciesItemViewModel: SpeciesItemViewModel
        = SpeciesItemViewModel(dataService: .shared)
    @State private var isLoading: Bool = true
    
    @AppStorage("hideObserved") private var hideObserved: Bool = false
    
//    private var savedSpeciesDict: [Int: SavedSpecies] {
//        Dictionary(uniqueKeysWithValues: savedSpecies.map { ($0.taxonId, $0) })
//    }
//    
//    private var filteredSpecies: [Species] {
//        print("filteredSpecies")
//        if hideObserved {
//            return speciesViewModel.species.filter {
//                !savedSpeciesDict.keys.contains($0.id)
//            }
//        } else {
//            return speciesViewModel.species
//        }
//    }
//    
//    private var filteredFamilies: [Family] {
//        print("filteredFamilies")
//        return Dictionary(grouping: filteredSpecies) {
//            $0.ancestors.first(where: { $0.rank == .family }) ?? Taxon.Constants.unknownTaxon
//        }.map {
//            let familyAncestors: [Taxon] = $1.first?.ancestors.filter({ $0.rank < .family }) ?? []
//            return .init(taxon: $0, ancestors: familyAncestors, species: $1)
//        }.sorted()
//    }
//    
    var body: some View {
        ZStack {
            ScrollView {
                Text(speciesItemViewModel.speciesCountText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Toggle("Only Show Unobserved", isOn: $hideObserved)
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                
                LazyVGrid(
                    columns: .init(repeating: GridItem(),count: 3),
                    alignment: .leading
                ) {
                    ForEach(speciesItemViewModel.speciesSections) { section in
                        Section {
                            ForEach(section.speciesItem) { speciesItem in
                                NavigationLink {
                                    SpeciesDetailView(speciesItem: speciesItem)
                                } label: {
                                    SpeciesItemView(speciesItem: speciesItem)
                                }
                                .navigationTitle("Species List")
                            }
////                                let observedStatusBinding = Binding(
////                                    get: {
////                                        /*savedSpeciesDict[species.id]?.hasLabel(.observed) ??*/ false
////                                    },
////                                    set: { newValue in
////                                        if newValue {
////                                            addLabel(for: species, label: .observed)
////                                        } else {
////                                            removeLabel(for: species, label: .observed)
////                                        }
////                                    }
////                                )
//                                
//                                NavigationLink {
//                                    EmptyView()
////                                    SpeciesDetailView(species: species
//////                                        species: species,
//////                                        observed: observedStatusBinding
////                                    )
//                                } label: {
//                                    EmptyView()
////                                    SpeciesItemView(species: species
////                                        species: species,
////                                        observed: observedStatusBinding
//                                    )
//                                }
//                                .navigationTitle("Species List")
//                            }
                        } header: {
                            Text(section.title)
                                .bold()
                                .padding([.leading, .trailing, .top])
                                .padding(.bottom, 3)
                        }
                    }
                }
                .task {
                    guard isLoading else { return }
                    
                    await speciesItemViewModel.fetchSpeciesCounts(category: category)
                    speciesItemViewModel.loadSavedSpecies()
                    speciesItemViewModel.generateFullSpeciesItems()
                    speciesItemViewModel.updateSpeciesSections()
                    
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
//        let taxonId = species.taxon.id
//        if savedSpeciesDict[taxonId] != nil {
//            savedSpecies.first(where: { $0.taxonId == taxonId })?.addLabel(label)
//        } else {
//            modelContext.insert(SavedSpecies(taxonId: taxonId, labels: [label]))
//        }
    }
    
    private func removeLabel(for species: Species, label: SavedSpecies.Label) {
//        guard let savedSpeciesItem = savedSpecies.first(where: { $0.taxonId == species.taxon.id })
//        else { return }
//        
//        savedSpeciesItem.removeLabel(label)
//        if savedSpeciesItem.labels.isEmpty {
//            modelContext.delete(savedSpeciesItem)
//        }
//        try? modelContext.save()
    }
}

#Preview {
    SpeciesListView(category: Category.bird.category)
}
