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
            let labelIconSize = SpeciesListView.Constants.labelIconSize
            VStack(spacing: 0) {
                ForEach(SpeciesListView.Constants.iconLabels, id: \.self) { label in
                    let hasLabel = speciesItem.labels.contains(label)
                    
                    Button {
                        if hasLabel {
                            speciesItemViewModel.removeLabel(
                                species: speciesItem.species, label: label
                            )
                        } else {
                            speciesItemViewModel.addLabel(
                                species: speciesItem.species, label: label
                            )
                        }
                    } label: {
                        Image(systemName: label.iconImage)
                            .resizable()
                            .scaledToFit()
                            .padding(4)
                            .shadow(color: .gray, radius: 2)
                    }
                    .frame(width: labelIconSize, height: labelIconSize)
                    .tint(speciesItem.labels.contains(label) ? label.iconActiveColor : .gray)
                }
            }
        }
    }
}

#Preview {
    SpeciesItemView(
        speciesItem: SpeciesItem.Constants.preview,
        speciesItemViewModel: SpeciesItemViewModel(dataService: .shared)
    )
}
