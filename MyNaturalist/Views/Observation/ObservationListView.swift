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
    
    @EnvironmentObject private var filterManager: FilterManager
    
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
                
                ZStack {
                    Color(UIColor.systemBackground)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(2)
                }
                .opacity(isLoading ? 1 : 0)
            }
            .task {
                guard isLoading else { return }
                
                let taxons = filterManager.taxonFilter.filter({ $0.isSelected }).map({ $0.taxon })
                
                await observationViewModel.fetchData(taxons: taxons)
                observations = observationViewModel.observations
                isLoading = false
            }
        }
    }
}

#Preview {
    ObservationListView()
}
