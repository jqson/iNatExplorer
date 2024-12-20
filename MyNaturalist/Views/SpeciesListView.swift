//
//  SpeciesView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesListView: View {
    
    @StateObject private var speciesViewModel = SpeciesViewModel()
    @State private var species: [Species] = []
    @State private var isLoading: Bool = true
    
    private var speciesCount: String {
        species.count <= 500 ? String(species.count) : "500 (max)"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Text("Species: \(speciesCount)")
                    
                    LazyVGrid(columns: .init(repeating: GridItem(),count: 3)) {
                        ForEach(species) { species in
                            NavigationLink(destination: SpeciesDetailView(species: species)) {
                                SpeciesItemView(species: species)
                            }
                            .navigationTitle("Species List")
                            .navigationBarHidden(true)
                        }
                    }
                    .task {
                        guard isLoading else { return }
                        
                        await speciesViewModel.fetchData()
                        species = speciesViewModel.species
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
