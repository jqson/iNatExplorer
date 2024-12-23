//
//  SearchView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/18/24.
//

import SwiftUI

struct SearchView: View {
    
    @State var taxonFilterItems: [SelectableItem] = []
    
    var taxons: [Taxon] {
        taxonFilterItems.filter({ $0.isSelected }).compactMap { ($0 as? SelectableTaxon)?.taxon }
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                FilterView(
                    filterItems: $taxonFilterItems,
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
        .onAppear() {
            taxonFilterItems = FilterManager.shared.taxonFilter.map { SelectableTaxon(taxon: $0) }
        }
    }
}

#Preview {
    SearchView()
}
