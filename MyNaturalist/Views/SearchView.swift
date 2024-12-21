//
//  SearchView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/18/24.
//

import SwiftUI

struct SearchView: View {
    
    @State var filterItems: [SelectableItem] = [
        SelectableTaxon(taxon: Taxon.Constants.greatHornedOwl),
        SelectableTaxon(taxon: Taxon.Constants.shortEaredOwl),
        SelectableTaxon(taxon: Taxon.Constants.americanBarnOwl),
    ]
    
    var taxons: [Taxon] {
        filterItems.filter({ $0.isSelected }).compactMap { ($0 as? SelectableTaxon)?.taxon }
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                FilterView(
                    filterItems: $filterItems,
                    filterTitle: "Species",
                    isMultipleSelection: true
                )
                
                NavigationLink(destination: ObservationListView(taxons: taxons)) {
                    Text("Search")
                        .font(.title2)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding()
                }
                .navigationTitle("Filter")
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    SearchView()
}
