//
//  SpeciesDetailView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/20/24.
//

import SwiftUI

struct SpeciesDetailView: View {
    
    var species: Species
    
    var body: some View {
        VStack {
            Text(species.name)
            
            AsyncImage(url: species.photo?.getUrl(.medium)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
        }
    }
}

#Preview {
    SpeciesDetailView(species: Species.Constants.preview)
}
