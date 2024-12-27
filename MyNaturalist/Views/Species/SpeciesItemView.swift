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
        ZStack(alignment: .bottom) {
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
            
            VStack {
                Text(verbatim: "\(species.name)\n\(species.count)")
                    .font(.callout)
                    .accentColor(.white)
                    .shadow(color: .black, radius: 2)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 4)
            }
        }
    }
}

#Preview {
    SpeciesItemView(species: Species.Constants.preview)
}
