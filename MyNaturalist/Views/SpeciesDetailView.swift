//
//  SpeciesDetailView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/20/24.
//

import SwiftUI

struct SpeciesDetailView: View {
    
    var species: Species
    
    @State private var inFilter: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(species.name)
                    .padding(.leading)
                
                Spacer()
                
                Button {
                    updateSpeciesFilter()
                } label: {
                    Text(inFilter ? "Remove Filter" : "Add Filter")
                }
            }
            .padding(.horizontal)
            
            AsyncImage(url: species.photo?.getUrl(.medium)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            
            let columns: [GridItem] = [
                GridItem(.fixed(120), alignment: .init(horizontal: .trailing, vertical: .top)),
                GridItem(.flexible(), alignment: .leading)
            ]
            
            LazyVGrid(columns: columns) {
                ForEach(species.ancestors) { ancestor in
                    Text("\(ancestor.rank.rawValue.capitalized):")
                    Text(ancestor.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .onAppear() {
            inFilter = FilterManager.shared.taxonInFilter(species.taxon)
        }
    }
    
    private func updateSpeciesFilter() {
        let filterManager = FilterManager.shared
        if inFilter {
            filterManager.removeTaxon(species.taxon)
        } else {
            filterManager.addTaxon(species.taxon)
        }
        
        inFilter.toggle()
    }
}

#Preview {
    SpeciesDetailView(species: Species.Constants.preview)
}
