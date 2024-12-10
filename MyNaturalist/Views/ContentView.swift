//
//  ContentView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var observationViewModel = ObservationViewModel()
    
    var body: some View {
        ObservationListView(observations: observationViewModel.observations)
        .onAppear {
            if observationViewModel.observations.isEmpty {
                Task {
                    await observationViewModel.fetchData()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
