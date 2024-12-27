//
//  ItemView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ObservationItemView: View {
    
    enum Constants {
        static let imageSize: CGFloat = 100
    }
    
    var observation: Observation
    
    var body: some View {
        HStack {
            AsyncImage(url: observation.photos.first?.getUrl(.small)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .clipped()
            
            
            VStack(alignment: .leading) {
                Text(observation.name)
                Text(observation.observedTime)
            }
        }
    }
}

#Preview {
    ObservationItemView(observation: Observation.Constants.preview)
}
