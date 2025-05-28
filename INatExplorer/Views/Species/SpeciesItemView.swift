//
//  SpeciesItemView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesItemView: View {
    
    var species: Species
    
    @Binding var isSighted: Bool
    
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
            .overlay(alignment: .bottom) {
                Text(verbatim: "\(species.name)\n\(species.count)")
                    .font(.callout)
                    .accentColor(.white)
                    .shadow(color: .black, radius: 2)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 4)
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    isSighted.toggle()
                } label: {
                    Image(systemName: "binoculars.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .shadow(color: .gray, radius: 2)
                }
                .frame(width: 35, height: 35)
                .tint(isSighted ? .orange : .gray)
            }
        }
    }
}

#Preview {
    @Previewable @State var isSighted: Bool = false
    
    SpeciesItemView(species: Species.Constants.preview, isSighted: $isSighted)
}
