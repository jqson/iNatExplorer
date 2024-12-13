//
//  ListView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ObservationListView: View {
    
    @StateObject var observationViewModel = ObservationViewModel()
    @State var observations: [Observation] = []
    @State var isLoading = true
    
    var taxons: [Taxon] = []
    
    var body: some View {
        NavigationSplitView {
            ZStack {
                List(observations) { observation in
                    NavigationLink(destination: ObservationDetailView(observation: observation)) {
                        ObservationItemView(observation: observation)
                    }
                }
                
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
        } detail: {
            Text("Select an item to view details")
        }
    }
}

#Preview {
    ObservationListView()
}
