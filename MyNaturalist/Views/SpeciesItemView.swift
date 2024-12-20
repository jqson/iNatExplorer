//
//  SpeciesItemView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesItemView: View {
    
    var species: Species
    
    var body: some View {
        VStack {
            AsyncImage(url: species.photo?.getUrl(.small)) { image in
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
            
            Text(species.name)
                .multilineTextAlignment(.center)
            
            Text(verbatim: "Count: \(species.count)")
        }
    }
}

#Preview {
    SpeciesItemView(species: Species.Constants.preview)
}
