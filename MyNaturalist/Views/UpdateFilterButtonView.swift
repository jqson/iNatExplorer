//
//  UpdateFilterButtonView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/25/24.
//

import SwiftUI

struct UpdateFilterButtonView: View {
    
    @EnvironmentObject private var filterManager: FilterManager
    @State private var showButton: Bool = false
    @State private var inFilter: Bool = false
    
    var taxon: Taxon?
    
    var body: some View {
        Button {
            updateSpeciesFilter()
        } label: {
            Text(inFilter ? "Remove Filter" : "Add Filter")
        }
        .opacity(showButton ? 1 : 0)
        .onAppear() {
            guard let taxon = taxon else {
                showButton = false
                return
            }
            showButton = true
            inFilter = filterManager.taxonInFilter(taxon)
        }
    }
    
    private func updateSpeciesFilter() {
        guard let taxon = taxon else { return }
        
        if inFilter {
            filterManager.removeTaxon(taxon)
        } else {
            filterManager.addTaxon(taxon)
        }
        
        inFilter.toggle()
    }
}

#Preview {
    UpdateFilterButtonView(taxon: Taxon.Constants.greatHornedOwl)
        .environmentObject(FilterManager())
}
