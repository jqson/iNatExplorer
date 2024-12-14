//
//  ContentView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var filterItems: [SelectableItem] = Taxon.allCases.map({ $0.info })
    var taxons: [Taxon] {
        filterItems.filter({ $0.isSelected }).compactMap { ($0 as? TaxonStruct)?.taxon }
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                FilterView(filterItems: $filterItems, isMultipleSelection: true)
                
                Spacer()
                
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
            }
        }
    }
}

#Preview {
    ContentView()
}
