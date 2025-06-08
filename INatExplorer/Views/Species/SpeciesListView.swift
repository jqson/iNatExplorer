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
    
    var body: some View {
        ZStack {
            ScrollView {
                Text(speciesItemViewModel.speciesCountText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Toggle("Only Show Unobserved", isOn: $speciesItemViewModel.hideObserved)
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                
                LazyVGrid(
                    columns: .init(repeating: GridItem(),count: 3),
                    alignment: .leading
                ) {
                    ForEach(speciesItemViewModel.speciesSections) { section in
                        Section {
                            ForEach(section.speciesItem) { speciesItem in
                                let observedStatusBinding = Binding(
                                    get: {
                                        speciesItem.labels.contains(.observed)
                                    },
                                    set: { newValue in
                                        if newValue {
                                            speciesItemViewModel.addLabel(
                                                species: speciesItem.species, label: .observed
                                            )
                                        } else {
                                            speciesItemViewModel.removeLabel(
                                                species: speciesItem.species, label: .observed
                                            )
                                        }
                                    }
                                )
                                
                                NavigationLink {
                                    SpeciesDetailView(
                                        species: speciesItem.species,
                                        speciesItemViewModel: speciesItemViewModel
                                    )
                                } label: {
                                    SpeciesItemView(
                                        speciesItem: speciesItem, observed: observedStatusBinding
                                    )
                                }
                                .navigationTitle("Species List")
                            }
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
}

#Preview {
    SpeciesListView(category: Category.bird.category)
}
