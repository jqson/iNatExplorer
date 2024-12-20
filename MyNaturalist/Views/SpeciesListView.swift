//
//  SpeciesView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesListView: View {
    
    @State var species: [Species]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            ForEach(species) { species in
                SpeciesItemView(species: species)
            }
        }
    }
}

#Preview {
    SpeciesListView(species: [Species.Constants.preview])
}
