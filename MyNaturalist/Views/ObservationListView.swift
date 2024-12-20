//
//  ListView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ObservationListView: View {
    
    @StateObject private var observationViewModel = ObservationViewModel()
    @State private var observations: [Observation] = []
    @State private var isLoading = true
    
    var taxons: [Taxon] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(observations) { observation in
                    NavigationLink(destination: ObservationDetailView(observation: observation)) {
                        ObservationItemView(observation: observation)
                    }
                    .navigationTitle("Search Results")
                }
                .listStyle(.plain)
                
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
            }
            .onAppear {
                Task {
                    await observationViewModel.fetchData(taxons: taxons)
                    observations = observationViewModel.observations
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ObservationListView()
}
