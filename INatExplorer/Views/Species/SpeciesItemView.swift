//
//  SpeciesItemView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesItemView: View {
    
    var speciesItem: SpeciesItem
    
    @Binding var observed: Bool
    @Binding var favorite: Bool
    
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
                Button {
                    observed.toggle()
                } label: {
                    Image(systemName: SpeciesListView.Constants.observedIcon)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .shadow(color: .gray, radius: 2)
                }
                .frame(width: labelIconSize, height: labelIconSize)
                .tint(observed ? .orange : .gray)
                
                Button {
                    favorite.toggle()
                } label: {
                    Image(systemName: SpeciesListView.Constants.favoriteIcon)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .shadow(color: .gray, radius: 2)
                }
                .frame(width: labelIconSize, height: labelIconSize)
                .tint(favorite ? .pink : .gray)
            }
        }
    }
}

#Preview {
    @Previewable @State var observed: Bool = true
    @Previewable @State var favorite: Bool = true
    
    SpeciesItemView(
        speciesItem: SpeciesItem.Constants.preview,
        observed: $observed,
        favorite: $favorite
    )
}
