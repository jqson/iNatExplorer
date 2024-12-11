//
//  ObservationDetailView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/9/24.
//

import SwiftUI

struct ObservationDetailView: View {
    
    var observation: Observation
    
    var body: some View {
        VStack {
            Text(observation.name)
            
            Text(observation.observedTime)
            
            if let placeName = observation.placeName {
                Text(placeName)
            }
            
            List(observation.photos, id: \.id) { photo in
                AsyncImage(url: photo.getUrl(.medium)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listRowSpacing(5)
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    ObservationDetailView(observation: Observation.Constants.preview)
}
