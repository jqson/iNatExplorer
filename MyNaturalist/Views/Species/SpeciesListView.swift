//
//  SpeciesListView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesListView: View {
    
    @StateObject private var speciesViewModel = SpeciesViewModel()
    @State private var families: [Family] = []
    @State private var speciesCount: Int = 0
    @State private var isLoading: Bool = true
    
    var category: CategoryStruct
    
    private var speciesCountDisplay: String {
        speciesCount <= 500 ? String(speciesCount) : "500 (max)"
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
                                    SpeciesItemView(species: species)
                                }
                                .navigationTitle("Species List")
                            }
                        } header: {
                            HStack {
                                Text(family.taxon.name)
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
}

#Preview {
    SpeciesListView(category: Category.bird.category)
        .environmentObject(FilterManager())
}
