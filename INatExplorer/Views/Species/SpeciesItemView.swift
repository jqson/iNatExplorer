//
//  SpeciesItemView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesItemView: View {
    
    var speciesItem: SpeciesItem
    
    /*@Binding */var observed: Bool = false
    
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
            Button {
//                observed.toggle()
            } label: {
                Image(systemName: SpeciesListView.Constants.observedIcon)
                    .resizable()
                    .scaledToFit()
                    .padding(4)
                    .shadow(color: .gray, radius: 2)
            }
            .frame(width: 35, height: 35)
            .tint(observed ? .orange : .gray)
        }
    }
}

#Preview {
    @Previewable @State var observed: Bool = false
    
    SpeciesItemView(speciesItem: SpeciesItem.Constants.preview/*, observed: $observed*/)
}
