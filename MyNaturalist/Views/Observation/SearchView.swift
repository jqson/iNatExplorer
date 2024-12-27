//
//  SearchView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/18/24.
//

import SwiftUI

struct SearchView: View {
    
    var body: some View {
        NavigationStack {
            VStack() {
                FilterView(filterType: .taxon)
                
                NavigationLink(destination: ObservationListView()) {
                    Text("Search")
                        .font(.title2)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .navigationTitle("Filter")
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(FilterManager())
}
