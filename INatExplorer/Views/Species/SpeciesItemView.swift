//
//  SpeciesItemView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesItemView: View {
    
    var speciesItem: SpeciesItem
    var speciesItemViewModel: SpeciesItemViewModel
    
    var body: some View {
        AsyncImage(url: speciesItem.species.photo?.getUrl(.small)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.gray
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        .overlay(alignment: .bottom) {
            Text(verbatim: "\(speciesItem.species.name)\n\(speciesItem.count ?? 0)")
                .font(.callout)
                .accentColor(.white)
                .shadow(color: .black, radius: 2)
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
        }
        .overlay(alignment: .topTrailing) {
            SpeciesLabelsView(
                species: speciesItem.species,
                speciesItemViewModel: speciesItemViewModel
            )
        }
    }
}

#Preview {
    SpeciesItemView(
        speciesItem: SpeciesItem.Constants.preview,
        speciesItemViewModel: SpeciesItemViewModel(dataService: .shared)
    )
}
