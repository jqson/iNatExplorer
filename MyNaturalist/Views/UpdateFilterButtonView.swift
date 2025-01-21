//
//  UpdateFilterButtonView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/25/24.
//

import SwiftUI
import SwiftData

struct UpdateFilterButtonView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var filters: [Filter]
    
    private var taxonFilter: Filter? {
        guard let taxon = taxon else { return nil }
        return filters.first {
            $0.filterType == .taxon(taxon)
        }
    }
    
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
            guard taxon != nil else {
                showButton = false
                return
            }
            showButton = true
            
            inFilter = taxonFilter != nil
        }
    }
    
    private func updateSpeciesFilter() {
        guard let taxon = taxon else { return }
        
        if inFilter {
            if let taxonFilter = taxonFilter {
                modelContext.delete(taxonFilter)
            }
        } else {
            modelContext.insert(Filter(filterType: .taxon(taxon), isSelected: false))
            try? modelContext.save()
        }
        
        inFilter.toggle()
    }
}

#Preview {
    UpdateFilterButtonView(taxon: Taxon.Constants.greatHornedOwl)
}
