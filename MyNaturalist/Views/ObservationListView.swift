//
//  ListView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ObservationListView: View {
    
    var observations: [Observation]
    
    var body: some View {
        NavigationSplitView {
            List(observations) { observation in
                NavigationLink {
                    ObservationDetailView(observation: observation)
                } label: {
                    ObservationItemView(observation: observation)
                }
            }
        } detail: {
            Text("Select an item to view details")
        }
    }
}

#Preview {
    let observation: Observation = Observation.Constants.preview
    ObservationListView(observations: [observation, observation, observation])
}
