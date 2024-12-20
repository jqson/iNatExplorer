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
    
    private var speciesCount: String {
        species.count <= 500 ? String(species.count) : "500 (max)"
    }
    
    var body: some View {
        ScrollView {
            Text("Species: \(speciesCount)")
            
            LazyVGrid(columns: .init(repeating: GridItem(),count: 3)) {
                ForEach(species) { species in
                    SpeciesItemView(species: species)
                }
            }
            .onAppear() {
                Task {
                    await speciesViewModel.fetchData()
                    species = speciesViewModel.species
                }
            }
        }
    }
}

#Preview {
    SpeciesListView()
}
