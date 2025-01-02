//
//  ObservationDetailView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/9/24.
//

import SwiftUI

struct ObservationDetailView: View {
    
    var observation: Observation
    @StateObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text(observation.name)
                    .padding(.leading)
                    .bold()
                
                Spacer()
                
                UpdateFilterButtonView(taxon: observation.taxon)
            }
            .padding()
            
            Text(observation.observedTime)
            
            Text(locationViewModel.location?.displayAddress ?? "Failed to get address")
            
            if let description = observation.description, !description.isEmpty {
                Text("\"\(description)\"")
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            
            List(observation.photos, id: \.id) { photo in
                AsyncImage(url: photo.getUrl(.medium)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listRowSpacing(5)
            .listStyle(PlainListStyle())
        }
        .onAppear {
            Task {
                await locationViewModel.fetchData(coordinates: observation.coordinates)
            }
        }
    }
}

#Preview {
    ObservationDetailView(observation: Observation.Constants.preview)
        .environmentObject(FilterManager())
}
