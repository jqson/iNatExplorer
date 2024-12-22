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
    }
}

#Preview {
    SpeciesDetailView(species: Species.Constants.preview)
}
