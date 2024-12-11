//
//  ContentView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var observationViewModel = ObservationViewModel()
    @State var isLoading = true
    
    var body: some View {
        ZStack {
            
            ObservationListView(observations: observationViewModel.observations)
            .onAppear {
                if observationViewModel.observations.isEmpty {
                    Task {
                        await observationViewModel.fetchData()
                        isLoading = false
                    }
                }
            }
            
            ProgressView()
                .opacity(isLoading ? 1 : 0)
        }
    }
}

#Preview {
    ContentView()
}
