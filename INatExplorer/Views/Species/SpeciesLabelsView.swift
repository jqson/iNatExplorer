//
//  SpeciesLabelsView.swift
//  iNatExplorer
//
//  Created by Yuanfeng Jiao on 6/15/25.
//

import SwiftUI

struct SpeciesLabelsView: View {
    
    enum Constants {
        static let iconLabels: [SavedSpecies.Label] = [.observed, .favorite]
        static let labelIconSize: CGFloat = 32
    }
    
    var species: Species
    @StateObject var speciesItemViewModel: SpeciesItemViewModel
    
    var body: some View {
        let labelIconSize = Constants.labelIconSize
        VStack(spacing: 0) {
            ForEach(Constants.iconLabels, id: \.self) { label in
                let hasLabel = speciesItemViewModel.hasLabel(species: species, label: label)
                
                Button {
                    if hasLabel {
                        speciesItemViewModel.removeLabel(species: species, label: label)
                    } else {
                        speciesItemViewModel.addLabel(species: species, label: label)
                    }
                } label: {
                    Image(systemName: label.iconImage)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .shadow(color: .gray, radius: 2)
                }
                .frame(width: labelIconSize, height: labelIconSize)
                .tint(hasLabel ? label.iconActiveColor : .gray)
            }
        }
    }
}

#Preview {
    SpeciesLabelsView(
        species: Species.Constants.preview,
        speciesItemViewModel: SpeciesItemViewModel(dataService: .shared)
    )
}
