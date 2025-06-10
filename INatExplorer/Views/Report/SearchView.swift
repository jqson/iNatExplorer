//
//  SearchView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/18/24.
//

import SwiftUI

@available(*, deprecated)
struct SearchView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        FilterView(filterSection: .taxon)
                    }
                }
                
                NavigationLink(destination: ReportListView(taxons: [])) {
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
}
