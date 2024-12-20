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
            AsyncImage(url: species.photo?.getUrl(.square)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            
            Text(species.name)
        }
    }
}

#Preview {
    SpeciesItemView(species: Species.Constants.preview)
}
