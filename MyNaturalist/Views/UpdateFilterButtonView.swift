//
//  UpdateFIlterButton.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/25/24.
//

import SwiftUI

struct UpdateFilterButtonView: View {
    
    @EnvironmentObject private var filterManager: FilterManager
    @State private var inFilter: Bool = false
    
    var species: Species
    
    var body: some View {
        Button {
            updateSpeciesFilter()
        } label: {
            Text(inFilter ? "Remove Filter" : "Add Filter")
        }
        .onAppear() {
            inFilter = filterManager.taxonInFilter(species.taxon)
        }
    }
    
    private func updateSpeciesFilter() {
        if inFilter {
            filterManager.removeTaxon(species.taxon)
        } else {
            filterManager.addTaxon(species.taxon)
        }
        
        inFilter.toggle()
    }
}

#Preview {
    UpdateFilterButtonView(species: Species.Constants.preview)
        .environmentObject(FilterManager())
}
