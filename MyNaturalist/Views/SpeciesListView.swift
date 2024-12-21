//
//  SpeciesView.swift
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
    
    private var speciesCountDisplay: String {
        speciesCount <= 500 ? String(speciesCount) : "500 (max)"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Text("Species: \(speciesCount)")
                    
                    LazyVGrid(columns: .init(repeating: GridItem(),count: 3), pinnedViews: .sectionHeaders) {
                        ForEach(families) { family in
                            Section(header: Text(family.taxon.name)) {
                                ForEach(family.species) { species in
                                    NavigationLink(destination: SpeciesDetailView(species: species)) {
                                        SpeciesItemView(species: species)
                                    }
                                    .navigationTitle("Species List")
                                    .navigationBarHidden(true)
                                }
                            }
                        }
                    }
                    .task {
                        guard isLoading else { return }
                        
                        await speciesViewModel.fetchData()
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
}

#Preview {
    SpeciesListView()
}
